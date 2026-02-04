#!/usr/bin/env bash
#
# Git homework automation script – Exercise Set 1 + Set 2 preparation & execution
#

set -euo pipefail

WORK_DIR="$HOME/git-homework-practice"

echo "→ Cleaning previous workspace..."
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

echo "→ Initializing repository..."
git init
git config user.name "Homework Student"
git config user.email "homework-$(date +%s)@example.local"

# ──────────────────────────────────────────────
#   Create files used in exercises
# ──────────────────────────────────────────────
echo "Creating practice files..."

touch file1.txt file2.txt file3.txt
touch config.yaml database.sql
touch test_null_pointer.py

cat > README.md << 'EOF'
# Git Practice Repository
Homework for undoing things + remotes
EOF

# Initial commit
git add .
git commit -m "Initial commit – project skeleton"

# ──────────────────────────────────────────────
# Exercise Set 1 – Commit Amendment
# ──────────────────────────────────────────────
echo "→ Exercise 1: Amending commit"

# Simulate the bad commit
echo "# Bad commit" >> README.md
git add README.md
git commit -m "Fix null pointer"

# Now amend + add missing file
echo "print('Null pointer fixed!')" > test_null_pointer.py
git add test_null_pointer.py README.md
git commit --amend -m "Fix null pointer and add tests"

echo "→ Exercise 1 done (amended commit)"

# ──────────────────────────────────────────────
# Exercise Set 1 – Selective staging
# ──────────────────────────────────────────────
echo "→ Exercise 2: Selective staging / unstaging"

echo "change A" >> file1.txt
echo "change B (should not be committed yet)" >> file2.txt
echo "change C" >> file3.txt

git add file1.txt file2.txt file3.txt

# Unstage file2
git restore --staged file2.txt

# Commit the correct ones
git commit -m "Update file1 and file3"

# Later – commit file2 separately
git add file2.txt
git commit -m "Separate commit for file2 changes"

echo "→ Exercise 2 done"

# ──────────────────────────────────────────────
# Exercise Set 1 – Discarding changes
# ──────────────────────────────────────────────
echo "→ Exercise 3: Discard config.yaml, keep database.sql"

echo "bad setting: debug=true" >> config.yaml
echo "ALTER TABLE users ADD COLUMN last_login TIMESTAMP;" >> database.sql

git add config.yaml database.sql

# Unstage & discard only config.yaml
git restore --staged   config.yaml
git restore            config.yaml

# Keep database.sql staged → commit it
git commit -m "Add last_login column to users"

echo "→ Exercise 3 done"

# ──────────────────────────────────────────────
# Prepare remotes (you MUST change these URLs!)
# ──────────────────────────────────────────────
echo "→ Preparing remotes (CHANGE THESE URLS YOURSELF!)"

# === CHANGE THESE TWO LINES ===
MY_ORIGIN_URL="https://github.com/YOUR-USERNAME/git-practice.git"
MY_MIRROR_URL="https://github.com/YOUR-USERNAME/git-practice-mirror.git"

git remote add origin    "$MY_ORIGIN_URL"
git remote add upstream  https://github.com/python/cpython.git   # just for demo
git remote add mirror    "$MY_MIRROR_URL"

git branch -M main

# Optional – push current state to origin
# git push -u origin main

echo "Remotes configured:"
git remote -v

# ──────────────────────────────────────────────
# Exercise Set 2 – Syncing with upstream
# ──────────────────────────────────────────────
echo "→ Exercise: Fetch + merge from upstream (demo)"

git fetch --all --prune

# Usually you would do:
# git checkout main
# git merge upstream/main      # or rebase
# git push origin main

echo "(merge not executed automatically – review manually)"

# ──────────────────────────────────────────────
# Mirror push alias
# ──────────────────────────────────────────────
echo "→ Adding pushall alias (origin + mirror)"

git config alias.pushall '!f() { git push --all origin && git push --tags origin && git push --all mirror && git push --tags mirror; }; f'

echo "You can now run:   git pushall"

# ──────────────────────────────────────────────
# Recovery simulation (reflog demo – not automated)
# ──────────────────────────────────────────────
echo ""
echo "→ For recovery / force-push simulation:"
echo "  You can use:   git reflog"
echo "  Example recovery branch:"
echo "     git branch recover-lost-work HEAD@{5}"
echo ""

echo "============================================================="
echo "Homework script finished."
echo ""
echo "Workspace:   $WORK_DIR"
echo "Current branch: $(git branch --show-current)"
echo "Commits so far:"
git log --oneline --graph --decorate -8
echo "============================================================="

# ──────────────────────────────────────────────
# Make executable
# ──────────────────────────────────────────────
chmod +x git-homework.sh

# ──────────────────────────────────────────────
# Run
# ──────────────────────────────────────────────
./git-homework.sh