#!/usr/bin/env bash
set -euo pipefail

if [ $# -eq 0 ]; then
  echo "No version provided. Attempting to fetch the latest version from AdsPower website..."

  # Stricter regex targeting the exact download URL path to avoid grabbing SunBrowser/Chromium versions
  VERSION=$(curl -sL https://www.adspower.com/download | grep -oP 'software/linux-x64-global/\K[0-9]+\.[0-9]+\.[0-9]+' | head -n 1 || true)

  if [ -z "$VERSION" ]; then
    echo "Auto-fetch failed. AdsPower likely changed their website structure."
    echo "Fallback Usage: $0 <version>"
    echo "Example: $0 8.4.3"
    exit 1
  fi
  echo "Found latest version: $VERSION"
else
  VERSION=$1
fi

URL="https://version.adspower.net/software/linux-x64-global/${VERSION}/AdsPower-Global-${VERSION}-x64.deb"

echo "Prefetching Nix SRI hash for AdsPower v${VERSION}..."
HASH=$(nix store prefetch-file --hash-type sha256 "$URL" --json | jq -r .hash)

echo "Writing to sources.json..."
jq --arg ver "$VERSION" --arg url "$URL" --arg hash "$HASH" \
  '.version = $ver | .url = $url | .hash = $hash' sources.json >sources.json.tmp

mv sources.json.tmp sources.json

echo "Done. sources.json is now tracking v${VERSION}."
