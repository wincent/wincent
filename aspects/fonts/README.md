# Installs font files

## Updating the "Rec Mono Custom" font

```
cd .cache/repos/github/arrowtype/recursive-code-config
```

Make a small edit to `requirements.txt`, because the `python3` on this machine (from Homebrew):

```
$ python3 --version
Python 3.14.2
$ which -a python3
/opt/homebrew/bin/python3
/usr/bin/python3
```

hates some of the versions in the `requirements.txt`:

```
diff --git a/requirements.txt b/requirements.txt
index f12db88..62ff007 100644
--- a/requirements.txt
+++ b/requirements.txt
@@ -8,10 +8,10 @@ font-v==1.0.5
 opentype-feature-freezer==1.32.2
 
 # to remove components in code ligatures for improved rendering
-skia-pathops==0.7.4
+skia-pathops==0.9.1
 
 # to parse YAML config file
-pyyaml==5.4.1
+pyyaml>=6.0
 
 # to autohint output fonts
 ttfautohint-py>=0.5.0
\ No newline at end of file
```

Then:

```
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Build:

```
python3 scripts/instantiate-code-fonts.py ../../../../../aspects/fonts/files/custom.yaml
python3 scripts/instantiate-code-fonts.py ../../../../../aspects/fonts/files/light.yaml
```

Copy the built files (run from repo root):

```
cp \
  .cache/repos/github/arrowtype/recursive-code-config/fonts/RecMonoCustom/*.ttf \
  .cache/repos/github/arrowtype/recursive-code-config/fonts/RecMonoLight/*.ttf \
  aspects/fonts/files/
```

Finally, run install the fonts into `~/Library/Fonts/`:

```
# Delete old versions (if any).
rm -f ~/Library/Fonts/RecMono{Custom,Light}-*.ttf

# Install new versions.
./install fonts
```

The config files are based on "RecMonoLinear" (defined in `.cache/repos/github/arrowtype/recursive-code-config/premade-configs/linear.yaml`), with adjusted `wght` values, which were initially chosen to get us as close as possible to the visual weight of the Source Code Pro fonts that I was using. In the end, it was pretty close, except for "Italic", which was too heavy (and we can't go any lower than 300, so we're stuck with it). Based on testing with my external monitor, I latter bumped the regular weight up by 50 to create a bit more distance between the italic and regular weights[^italics], and bumped the bold weights up by 100 to create more distance between those and the regular weights. Given that I'm indecisive, I ended up creating two variants, a "Light" version (close to Source Code Pro) and a "Custom" version (a wee bit heavier):

[^italics]: Otherwise, italic looks too bold relative to the regular font, which is a problem because italics are used in code comments, which are supposed to be subtle.

| Variant    | "Linear" weight | "Custom" weight | "Light" weight | Weight to approximate Source Code Pro |
| ---------- | --------------- | --------------- | -------------- | ------------------------------------- |
| Regular    | 400             | 350             | 300            | 300                                   |
| Italic     | 400             | 300             | 300            | 300 (ideally, would be lighter)       |
| Bold       | 700             | 500             | 500            | 400                                   |
| BoldItalic | 700             | 500             | 500            | 400                                   |

