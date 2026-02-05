"""
    Script to include PowerLine glyphs by merging powerline-only TTFs with Rec Mono TTFs.
    More background at https://github.com/arrowtype/recursive/issues/351

    Work in progress.
    - Current blocker: PUA unicodes for glyphs like the "branch" arrow are getting dropped.
"""


from fontTools.merge import Merger

def mergePowerlineFont(fontpath, powerlineFontPath):

    merged = Merger().merge([fontpath, powerlineFontPath])

    merged.save(fontpath)

