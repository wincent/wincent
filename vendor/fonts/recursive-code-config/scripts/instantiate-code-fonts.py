"""
    A script to generate Recursive fonts for code with Regular, Italic, Bold, & Bold Italic,
    as configured in config.yaml. See Readme for usage instructions.

    Run from the directory above, pointing to a config and a variable font path, e.g.

    python3 scripts/instantiate-code-fonts.py <premade-configs/casual.yaml>
"""

import os
import pathlib
import glob
from fontTools import ttLib
import subprocess
import shutil
import yaml
import sys
import logging
import ttfautohint
from fontTools.varLib import instancer
from fontTools.varLib.instancer import OverlapMode
from opentype_feature_freezer import cli as pyftfeatfreeze
from dlig2calt import dlig2calt
from mergePowerlineFont import mergePowerlineFont
from ttfautohint.options import USER_OPTIONS as ttfautohint_options

# prevents over-active warning logs
logging.getLogger("opentype_feature_freezer").setLevel(logging.ERROR)

# if you provide a custom config path, this picks it up
try:
    configPath = sys.argv[1]
except IndexError:
    configPath = './config.yaml'

# gets font path passed in
try:
    fontPath = sys.argv[2] # allows custom path to be passed in, helpful for generating new release from arrowtype/recursive dir
except IndexError:
    fontPath =  glob.glob('./font-data/Recursive_VF_*.ttf')[0] # allows script to run without font path passed in.

# read yaml config
with open(configPath, encoding='utf-8') as file:
    fontOptions = yaml.load(file, Loader=yaml.FullLoader)

# GET / SET NAME HELPER FUNCTIONS

def getFontNameID(font, ID, platformID=3, platEncID=1):
    name = str(font["name"].getName(ID, platformID, platEncID))
    return name


def setFontNameID(font, ID, newName):

    print(f"\n\t• name {ID}:")
    macIDs = {"platformID": 3, "platEncID": 1, "langID": 0x409}
    winIDs = {"platformID": 1, "platEncID": 0, "langID": 0x0}

    oldMacName = font["name"].getName(ID, *macIDs.values())
    oldWinName = font["name"].getName(ID, *winIDs.values())

    if oldMacName != newName:
        print(f"\t\t Mac name was '{oldMacName}'")
        font["name"].setName(newName, ID, *macIDs.values())
        print(f"\t\t Mac name now '{newName}'")

    if oldWinName != newName:
        print(f"\t\t Win name was '{oldWinName}'")
        font["name"].setName(newName, ID, *winIDs.values())
        print(f"\t\t Win name now '{newName}'")


# ----------------------------------------------
# MAIN FUNCTION

oldName = "Recursive"

def splitFont(
        outputDirectory=f"RecMono{fontOptions['Family Name']}".replace(" ",""),
        newName="Rec Mono",
):

    # access font as TTFont object
    varfont = ttLib.TTFont(fontPath)

    fontFileName = os.path.basename(fontPath)


    outputSubDir = f"fonts/{outputDirectory}"

    for instance in fontOptions["Fonts"]:

        print("\n--------------------------------------------------------------------------------------\n" + instance)

        instanceFont = instancer.instantiateVariableFont(
            varfont,
            {
                "wght": fontOptions["Fonts"][instance]["wght"],
                "CASL": fontOptions["Fonts"][instance]["CASL"],
                "MONO": fontOptions["Fonts"][instance]["MONO"],
                "slnt": fontOptions["Fonts"][instance]["slnt"],
                "CRSV": fontOptions["Fonts"][instance]["CRSV"],
            },
            overlap=OverlapMode.REMOVE
        )

        # UPDATE NAME ID 6, postscript name
        currentPsName = getFontNameID(instanceFont, 6)
        newPsName = (currentPsName\
            .replace("Sans", "")\
            .replace(oldName,newName.replace(" ", "") + fontOptions['Family Name'].replace(" ",""))\
            .replace("LinearLight", instance.replace(" ", "")))
        setFontNameID(instanceFont, 6, newPsName)

        # UPDATE NAME ID 4, full font name
        currentFullName = getFontNameID(instanceFont, 4)
        newFullName = (currentFullName\
            .replace("Sans", "")\
            .replace(oldName, newName + " " + fontOptions['Family Name'])\
            .replace(" Linear Light", instance))\
            .replace(" Regular", "")
        setFontNameID(instanceFont, 4, newFullName)

        # UPDATE NAME ID 3, unique font ID
        currentUniqueName = getFontNameID(instanceFont, 3)
        newUniqueName = (currentUniqueName.replace(currentPsName, newPsName))
        setFontNameID(instanceFont, 3, newUniqueName)

        # ADD name 2, style linking name
        newStyleLinkingName = instance
        setFontNameID(instanceFont, 2, newStyleLinkingName)
        setFontNameID(instanceFont, 17, newStyleLinkingName)

        # UPDATE NAME ID 1, Font Family name
        currentFamName = getFontNameID(instanceFont, 1)
        newFamName = (newFullName.replace(f" {instance}", ""))
        setFontNameID(instanceFont, 1, newFamName)
        setFontNameID(instanceFont, 16, newFamName)

        newFileName = fontFileName\
            .replace(oldName, (newName + fontOptions['Family Name']).replace(" ", ""))\
            .replace("_VF_", "-" + instance.replace(" ", "") + "-")

        # make dir for new fonts
        pathlib.Path(outputSubDir).mkdir(parents=True, exist_ok=True)

        # -------------------------------------------------------
        # save instance font

        outputPath = f"{outputSubDir}/{newFileName}"

        # save font
        instanceFont.save(outputPath)

        # -------------------------------------------------------
        # Code font special stuff in post processing

        # freeze in rvrn & stylistic set features with pyftfeatfreeze
        pyftfeatfreeze.main([f"--features=rvrn,{','.join(fontOptions['Features'])}", outputPath, outputPath])

        if fontOptions['Code Ligatures']:
            # swap dlig2calt to make code ligatures work in old code editor apps
            dlig2calt(outputPath, inplace=True)

        # if casual, merge with casual PL; if linear merge w/ Linear PL
        if fontOptions["Fonts"][instance]["CASL"] > 0.5:
            mergePowerlineFont(outputPath, "./font-data/NerdfontsPL-Regular Casual.ttf")
        else:
            mergePowerlineFont(outputPath, "./font-data/NerdfontsPL-Regular Linear.ttf")

        # TODO, maybe: make VF for powerline font, then instantiate specific CASL instance before merging

        # -------------------------------------------------------
        # OpenType Table fixes

        monoFont =  ttLib.TTFont(outputPath)

        # drop STAT table to allow RIBBI style naming & linking on Windows
        try:
            del monoFont["STAT"]
        except KeyError:
            print("Font has no STAT table.")

        # In the post table, isFixedPitched flag must be set in the code fonts
        monoFont['post'].isFixedPitch = 1

        # In the OS/2 table Panose bProportion must be set to 9
        monoFont["OS/2"].panose.bProportion = 9

        # Also in the OS/2 table, xAvgCharWidth should be set to 600 rather than 612 (612 is an average of glyphs in the "Mono" files which include wide ligatures).
        monoFont["OS/2"].xAvgCharWidth = 600

        # Code to fix fsSelection adapted from:
        # https://github.com/googlefonts/gftools/blob/a0b516d71f9e7988dfa45af2d0822ec3b6972be4/Lib/gftools/fix.py#L764

        old_selection = fs_selection = monoFont["OS/2"].fsSelection

        # turn off all bits except for bit 7 (USE_TYPO_METRICS)
        fs_selection &= 1 << 7

        if instance == "Italic":

            monoFont["head"].macStyle = 0b10
            # In the OS/2 table Panose bProportion must be set to 11 for "oblique boxed" (this is partially a guess)
            monoFont["OS/2"].panose.bLetterForm = 11

            # set Italic bit
            fs_selection |= 1 << 0

        if instance == "Bold":
            monoFont['OS/2'].fsSelection = 0b100000
            monoFont["head"].macStyle = 0b1

            # set Bold bit
            fs_selection |= 1 << 5

        if instance == "Bold Italic":
            monoFont['OS/2'].fsSelection = 0b100001
            monoFont["head"].macStyle = 0b11

            # set Italic & Bold bits
            fs_selection |= 1 << 0
            fs_selection |= 1 << 5


        monoFont["OS/2"].fsSelection = fs_selection


        monoFont.save(outputPath)

        # TTF autohint

        ttfautohint_options.update(
                                    in_file=outputPath,
                                    out_file=outputPath,
                                    hint_composites=True
                                    )

        ttfautohint.ttfautohint()

        print(f"\n→ Font saved to '{outputPath}'\n")


        print('Features are ', fontOptions['Features'])

splitFont()
