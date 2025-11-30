#!/bin/bash
set -e

# Usage: ./bump_version.sh [develop|production] [major|minor|patch]

MODE=$1
TYPE=${2:-patch}

PUBSPEC_FILE="pubspec.yaml"
VERSION_FILE="app_version.txt"

# 1. Read current version from app_version.txt
if [ ! -f "$VERSION_FILE" ]; then
  echo "Error: $VERSION_FILE not found."
  exit 1
fi

FULL_VERSION=$(cat "$VERSION_FILE")

# Validate format
if [[ $FULL_VERSION =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\+([0-9]+)$ ]]; then
  MAJOR="${BASH_REMATCH[1]}"
  MINOR="${BASH_REMATCH[2]}"
  PATCH="${BASH_REMATCH[3]}"
  BUILD="${BASH_REMATCH[4]}"
else
  echo "Error: Invalid version format in $VERSION_FILE: $FULL_VERSION"
  echo "Expected format: X.Y.Z+BUILD"
  exit 1
fi

# 2. Calculate New Version
NEW_BUILD=$((BUILD + 1))

if [ "$MODE" == "production" ]; then
  if [ "$TYPE" == "major" ]; then
    MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0
  elif [ "$TYPE" == "minor" ]; then
    MINOR=$((MINOR + 1)); PATCH=0
  else
    PATCH=$((PATCH + 1))
  fi
  NEW_VERSION="$MAJOR.$MINOR.$PATCH+$NEW_BUILD"
else
  NEW_VERSION="$MAJOR.$MINOR.$PATCH+$NEW_BUILD"
fi

echo "Bumping version: $FULL_VERSION -> $NEW_VERSION"

# 3. Update Files
echo "$NEW_VERSION" > "$VERSION_FILE"
sed -i -E "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC_FILE"

# 4. Output for GitHub Actions
if [ -n "$GITHUB_OUTPUT" ]; then
  echo "NEW_VERSION=$NEW_VERSION" >> "$GITHUB_OUTPUT"
fi