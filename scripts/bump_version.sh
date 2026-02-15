#!/bin/bash
set -e

# Usage: ./bump_version.sh <PROJECT_DIR> <MODE> [TYPE]

PROJECT_DIR=$1
MODE=$2
TYPE=${3:-patch}

if [ -z "$PROJECT_DIR" ]; then
  echo "Error: Project directory argument missing."
  exit 1
fi

VERSION_FILE="$PROJECT_DIR/app_version.txt"
PUBSPEC_FILE="$PROJECT_DIR/pubspec.yaml"

if [ ! -f "$VERSION_FILE" ]; then
  echo "Error: $VERSION_FILE not found."
  exit 1
fi

FULL_VERSION=$(cat "$VERSION_FILE")

if [[ $FULL_VERSION =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\+([0-9]+)$ ]]; then
  MAJOR="${BASH_REMATCH[1]}"
  MINOR="${BASH_REMATCH[2]}"
  PATCH="${BASH_REMATCH[3]}"
  BUILD="${BASH_REMATCH[4]}"
else
  echo "Error: Invalid format $FULL_VERSION. Expected X.Y.Z+BUILD"
  exit 1
fi

NEW_BUILD=$((BUILD + 1))

if [ "$MODE" == "production" ]; then
  if [ "$TYPE" == "major" ]; then
    MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0
  elif [ "$TYPE" == "minor" ]; then
    MINOR=$((MINOR + 1)); PATCH=0
  else
    PATCH=$((PATCH + 1))
  fi
fi

NEW_VERSION="$MAJOR.$MINOR.$PATCH+$NEW_BUILD"
echo "Bumping: $FULL_VERSION -> $NEW_VERSION"

echo "$NEW_VERSION" > "$VERSION_FILE"

sed -i.bak -E "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC_FILE" && rm "${PUBSPEC_FILE}.bak"

if [ -n "$GITHUB_OUTPUT" ]; then
  echo "NEW_VERSION=$NEW_VERSION" >> "$GITHUB_OUTPUT"
fi