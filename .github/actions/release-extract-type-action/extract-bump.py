#!/usr/bin/env python3

import argparse
import re

def main():
    parser = argparse.ArgumentParser(
        description="Extract the bump type from the PR labels.")

    parser.add_argument(
        "labels",
        help="the comma-separated list of PR labels")

    args = parser.parse_args()

    types = extract_release_types(args.labels)
    if len(types) == 0:
        raise ValueError("No release type found in labels")

    if len(types) > 1:
        raise ValueError("Multiple release types found in labels")

    bump_type = types[0]
    print(bump_type)

def extract_release_types(labels):
    LABEL_REGEX = re.compile(r"\b(?<=1\.release: )[^,]+\b")
    return LABEL_REGEX.findall(labels)

if __name__ == "__main__":
    main()
