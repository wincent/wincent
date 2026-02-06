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

Copy the "linear" config into place:

```
cp premade-configs/linear.yaml config.yaml
```

And modify it:

- Change "Family Name" to "Custom"
- Reduce `wght` values as follows:
  - For `Regular`, reduce from 400 to 350.
  - For `Italic`, reduce from 400 to 300 (the minimum).
  - For `Bold`, reduce from 700 to 500.
  - For `BoldItalic`, reduce from 700 to 500.

yielding this:

```
# Configuration for Rec Mono Linear
# Here as an example, or to tweak & use if you wish to
# See README for details.

Family Name: Custom

Fonts:
  Regular:
    MONO: 1
    CASL: 0
    wght: 350
    slnt: 0
    CRSV: 0
  Italic:
    MONO: 1
    CASL: 0
    wght: 300
    slnt: -10
    CRSV: 1
  Bold:
    MONO: 1
    CASL: 0
    wght: 500
    slnt: 0
    CRSV: 0
  Bold Italic:
    MONO: 1
    CASL: 0
    wght: 500
    slnt: -10
    CRSV: 1

Code Ligatures: True

Features:
- ss03 # Simplified f
- ss05 # Simplified l
- ss08 # Serifless L and Z
- ss09 # Simplified 6 and 9
- ss12 # Simplified @
```

The `wght` values were initially chosen to get us as close as possible to the visual weight of the Source Code Pro fonts that I was using. In the end, it was pretty close, except for "Italic", which was too heavy (and we can't go any lower than 300, so we're stuck with it). Based on testing with my external monitor, I latter bumped the regular weight up by 50 to create a bit more distance between the italic and regular weights[^italics], and bumped the bold weights up by 100 to create more distance between those and the regular weights.

[^italics]: Otherwise, italic looks too bold relative to the regular font, which is a problem because italics are used in code comments, which are supposed to be subtle.

| Variant    | Rec Mono Linear weight | Weight to approximate Source Code Pro | Rec Mono Custom weight |
| ---------- | ---------------------- | ------------------------------------- | ---------------------- |
| Regular    | 400                    | 300                                   | 350                    |
| Italic     | 400                    | 300                                   | 300                    |
| Bold       | 700                    | 400                                   | 500                    |
| BoldItalic | 700                    | 400                                   | 500                    |

Then build:

```
python3 scripts/instantiate-code-fonts.py
```

and copy the built files (run from repo root):

```
cp .cache/repos/github/arrowtype/recursive-code-config/fonts/RecMonoCustom/*.ttf \
  aspects/fonts/files/RecMonoCustom/
```
