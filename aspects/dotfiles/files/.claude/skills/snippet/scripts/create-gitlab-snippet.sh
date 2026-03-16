#!/bin/sh
#
# Create a GitLab snippet from a file or stdin.
#
# Usage:
#   create-gitlab-snippet.sh <file> [title]
#   pbpaste | create-gitlab-snippet.sh - [title]
#
# If SUMMARY_FILE is set and points to a readable file, its content is
# prepended as a Markdown summary before the fenced session transcript.
#
# Requires GITLAB_TOKEN and GITLAB_HOST to be set.

set -e

INPUT="$1"
TITLE="${2:-Claude Code Session - $(date '+%Y-%m-%d %H:%M')}"

if [ -z "$INPUT" ]; then
    echo "Usage: create-gitlab-snippet.sh <file|-> [title]" >&2
    exit 1
fi

if [ -z "$GITLAB_HOST" ]; then
    echo "Error: GITLAB_HOST not set" >&2
    exit 1
fi

if [ -z "$GITLAB_TOKEN" ]; then
    echo "Error: GITLAB_TOKEN not set" >&2
    exit 1
fi

if [ "$INPUT" = "-" ]; then
    FILE=$(mktemp)
    cat > "$FILE"
    CLEANUP=1
elif [ -f "$INPUT" ]; then
    FILE="$INPUT"
    CLEANUP=0
else
    echo "Error: file not found: $INPUT" >&2
    exit 1
fi

PAYLOAD=$(python3 -c "
import json, os, re, sys
with open(sys.argv[1]) as f:
    content = f.read()
max_run = 0
for m in re.finditer(r'\`{3,}', content):
    max_run = max(max_run, len(m.group()))
fence = '\`' * max(max_run + 1, 3)
wrapped = fence + '\n' + content + '\n' + fence + '\n'
summary_file = os.environ.get('SUMMARY_FILE', '')
if summary_file:
    with open(summary_file) as f:
        summary = f.read().rstrip('\n')
    body = summary + '\n\n---\n\n## Full Session Transcript\n\n' + wrapped
else:
    body = wrapped
payload = {
    'title': sys.argv[2],
    'visibility': 'internal',
    'files': [{'file_path': 'session.md', 'content': body}]
}
print(json.dumps(payload))
" "$FILE" "$TITLE")

[ "$CLEANUP" = 1 ] && rm -f "$FILE"

RESPONSE=$(curl -sS --max-time 30 \
    -H "PRIVATE-TOKEN: $GITLAB_TOKEN" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD" \
    "$GITLAB_HOST/api/v4/snippets")

URL=$(echo "$RESPONSE" | python3 -c "import json,sys; print(json.load(sys.stdin).get('web_url', ''))" 2>/dev/null)

if [ -n "$URL" ]; then
    echo "$URL"
else
    echo "Error creating snippet:" >&2
    echo "$RESPONSE" >&2
    exit 1
fi
