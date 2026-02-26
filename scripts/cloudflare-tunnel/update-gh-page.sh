#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="$HOME/.github-config"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "warning: $CONFIG_FILE not found; skipping GitHub update" >&2
    exit 0
fi

set -a
# shellcheck source=/dev/null
source "$CONFIG_FILE"
set +a

: "${GITHUB_TOKEN:?'GITHUB_TOKEN must be set in ~/.github-config'}"
: "${GITHUB_OWNER:?'GITHUB_OWNER must be set in ~/.github-config'}"
: "${GITHUB_REPO:?'GITHUB_REPO must be set in ~/.github-config'}"

GITHUB_BRANCH="${GITHUB_BRANCH:-config}"
GITHUB_FILE="${GITHUB_FILE:-config.json}"
COMMITTER_NAME="${COMMITTER_NAME:-GitHub Actions}"
COMMITTER_EMAIL="${COMMITTER_EMAIL:-actions@github.com}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tunnel_url="$("$SCRIPT_DIR/tunnel-url.sh" | sed -n 's/^Tunnel URL: //p')"

if [[ -z "$tunnel_url" ]]; then
    echo "error: could not retrieve tunnel URL" >&2
    exit 1
fi

echo "Tunnel URL: $tunnel_url"

json=$(printf '{"redirectUrl":"%s"}\n' "$tunnel_url")
content=$(printf '%s' "$json" | base64 | tr -d '\n')

API_URL="https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_REPO/contents/$GITHUB_FILE"

sha=$(curl -s \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "$API_URL?ref=$GITHUB_BRANCH" \
    | grep -o '"sha":[[:space:]]*"[^"]*"' | head -1 | sed 's/"sha":[[:space:]]*"//;s/"//' || true)

if [[ -n "$sha" ]]; then
    body=$(printf \
        '{"message":"chore: update tunnel URL to %s","committer":{"name":"%s","email":"%s"},"content":"%s","branch":"%s","sha":"%s"}' \
        "$tunnel_url" "$COMMITTER_NAME" "$COMMITTER_EMAIL" "$content" "$GITHUB_BRANCH" "$sha")
else
    body=$(printf \
        '{"message":"chore: add tunnel URL config","committer":{"name":"%s","email":"%s"},"content":"%s","branch":"%s"}' \
        "$COMMITTER_NAME" "$COMMITTER_EMAIL" "$content" "$GITHUB_BRANCH")
fi

response=$(curl -s -w "\n%{http_code}" -X PUT \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    -d "$body" \
    "$API_URL")

http_code=$(echo "$response" | tail -1)

if [[ "$http_code" == "200" || "$http_code" == "201" ]]; then
    echo "GitHub: updated $GITHUB_FILE on branch '$GITHUB_BRANCH'"
else
    echo "error: GitHub API returned HTTP $http_code" >&2
    echo "$response" | head -n -1 >&2
    exit 1
fi
