---
description: >-
  Generate meme images using popular templates. Use when the user asks to
  "make a meme", "create a meme", "generate a meme", "meme this",
  or references a specific meme template by name.
argument-hint: "[template name] [top text] [bottom text]"
allowed-tools:
  - Bash
  - AskUserQuestion
---

Generate a meme image using the imgflip API.

## Template table

Match the user's request against this table (case-insensitive, fuzzy). The
"Boxes" column indicates how many text arguments the template expects.

| ID | Boxes | Name |
|----|-------|------|
| 181913649 | 2 | Drake Hotline Bling |
| 87743020 | 3 | Two Buttons |
| 112126428 | 3 | Distracted Boyfriend |
| 217743513 | 2 | UNO Draw 25 Cards |
| 222403160 | 2 | Bernie I Am Once Again Asking For Your Support |
| 124822590 | 3 | Left Exit 12 Off Ramp |
| 322841258 | 3 | Anakin Padme 4 Panel |
| 252600902 | 2 | Always Has Been |
| 135256802 | 3 | Epic Handshake |
| 131940431 | 4 | Gru's Plan |
| 55311130 | 2 | This Is Fine |
| 80707627 | 3 | Sad Pablo Escobar |
| 97984 | 2 | Disaster Girl |
| 102156234 | 2 | Mocking Spongebob |
| 124055727 | 2 | Y'all Got Any More Of That |
| 4087833 | 2 | Waiting Skeleton |
| 129242436 | 2 | Change My Mind |
| 101470 | 2 | Ancient Aliens |
| 438680 | 2 | Batman Slapping Robin |
| 91538330 | 2 | X, X Everywhere |
| 188390779 | 2 | Woman Yelling At Cat |
| 161865971 | 2 | Marked Safe From |
| 247375501 | 4 | Buff Doge vs. Cheems |
| 195515965 | 4 | Clown Applying Makeup |
| 93895088 | 4 | Expanding Brain |
| 119139145 | 2 | Blank Nut Button |
| 61579 | 2 | One Does Not Simply |
| 178591752 | 2 | Tuxedo Winnie The Pooh |
| 100777631 | 3 | Is This A Pigeon |
| 61544 | 2 | Success Kid |
| 79132341 | 3 | Bike Fall |
| 110163934 | 2 | I Bet He's Thinking About Other Women |
| 180190441 | 3 | They're The Same Picture |
| 84341851 | 2 | Evil Kermit |
| 370867422 | 2 | Megamind peeking |
| 177682295 | 2 | You Guys are Getting Paid |
| 28251713 | 2 | Oprah You Get A |
| 148909805 | 2 | Monkey Puppet |
| 3218037 | 2 | This Is Where I'd Put My Trophy If I Had One |
| 110133729 | 2 | Spiderman Pointing at Spiderman |
| 67452763 | 2 | Squidward window |
| 27813981 | 2 | Hide the Pain Harold |
| 77045868 | 2 | Pawn Stars Best I Can Do |
| 1035805 | 4 | Boardroom Meeting Suggestion |
| 259237855 | 2 | Laughing Leo |
| 61520 | 2 | Futurama Fry |
| 226297822 | 3 | Panik Kalm Panik |
| 89370399 | 2 | Roll Safe Think About It |
| 284929871 | 2 | They don't know |
| 99683372 | 2 | Sleeping Shaq |
| 155067746 | 3 | Surprised Pikachu |
| 137501417 | 2 | Friendship ended |
| 5496396 | 2 | Leonardo Dicaprio Cheers |
| 14371066 | 2 | Star Wars Yoda |
| 196652226 | 2 | Spongebob Ight Imma Head Out |
| 61532 | 2 | The Most Interesting Man In The World |
| 1367068 | 2 | I Should Buy A Boat Cat |

## Steps

1. **Identify the template**: Match the user's request against the table above.
   If no match is found, try fetching from the API:
   ```
   curl -s https://api.imgflip.com/get_memes | python3 -c "
   import json, sys
   data = json.load(sys.stdin)
   query = sys.argv[1].lower()
   for m in data['data']['memes']:
       if query in m['name'].lower():
           print(f'{m[\"id\"]}  {m[\"box_count\"]}  {m[\"name\"]}')
   " "SEARCH_TERM"
   ```
   If still no match, ask the user to clarify.

2. **Collect text**: Based on the box count for the chosen template, ensure you
   have the right number of text strings. If the user hasn't provided enough,
   use AskUserQuestion to ask for them. Explain what each box represents for
   the chosen template (e.g. for Drake: box 1 = rejected thing, box 2 =
   preferred thing).

3. **Generate the meme**: Run the caption script:
   ```
   ~/.claude/skills/meme/scripts/caption.sh TEMPLATE_ID "text for box 0" "text for box 1" ...
   ```
   Parse the JSON response. On success, extract `data.url` and `data.page_url`.
   On failure, show the `error_message` to the user.

4. **Show the result**: Display the image URL to the user and open it:
   ```
   open "IMAGE_URL"
   ```

## Notes

- Requires `IMGFLIP_USERNAME` and `IMGFLIP_PASSWORD` environment variables.
  Free accounts work. Sign up at https://imgflip.com/signup
- The free tier adds a small watermark to generated images.
- If the user asks to "pick a template" or "show me templates", print the
  template table so they can choose.
- If the user describes a concept but doesn't name a template, pick the most
  fitting one from the table.
