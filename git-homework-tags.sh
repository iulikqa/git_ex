# ──────────────────────────────────────────────────────────────
#  PART 1 – Local machine: GPG + signed annotated tag
# ──────────────────────────────────────────────────────────────

#!/usr/bin/env bash
set -euo pipefail

echo "=== 1. Checking GPG installation ==="
if ! command -v gpg >/dev/null 2>&1; then
  echo "GPG is not installed. Install it first."
  exit 1
fi
gpg --version | head -n 1

echo
echo "=== 2. Listing secret keys ==="
gpg --list-secret-keys --keyid-format LONG

echo
echo "IMPORTANT:"
echo "Copy the KEY ID (the part after 'rsa4096/') and export it:"
echo "Example: A01E012C5DEF71C2"
echo

read -rp "Enter your GPG KEY ID: " GPG_KEY_ID

echo
echo "=== 3. Configuring Git to use GPG ==="
git config --global user.signingkey "$GPG_KEY_ID"
git config --global commit.gpgsign true
git config --global tag.gpgSign true

echo "Git GPG configuration:"
git config --global --get user.signingkey
git config --global --get tag.gpgSign

echo
echo "=== 4. Creating an annotated signed tag ==="
TAG_NAME="v1.0.0-signed"
TAG_MESSAGE="Signed release tag $TAG_NAME"

git tag -s "$TAG_NAME" -m "$TAG_MESSAGE"

echo
echo "Tag created:"
git show "$TAG_NAME"

echo
echo "=== 5. Verifying the tag signature ==="
git tag -v "$TAG_NAME"

echo
echo "SUCCESS: Annotated GPG-signed tag created and verified locally."
