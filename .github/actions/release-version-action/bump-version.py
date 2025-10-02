#!/usr/bin/env python3

import argparse
import re

def main():
    parser = argparse.ArgumentParser(
        description="Bump the version of a package.")

    parser.add_argument(
        "type",
        help="the type of bump to perform",
        choices=["major", "minor", "patch", "track"])

    parser.add_argument(
        "version",
        help="the version to bump (e.g. 3.1.4-alpha.43)")

    args = parser.parse_args()
    next_version = bump_version(args.version, args.type)
    print(next_version)

def parse_version(version):
    VERSION_REGEX = re.compile(r"^(?P<major>\d+)\.(?P<minor>\d+)\.(?P<patch>\d+)(?:-(?P<trackid>\w+)(?:\.(?P<track>\d+))?)?(?P<trail>.*)$")

    match = VERSION_REGEX.match(version)
    if match is None:
        raise ValueError(f"Invalid version: {version}")

    return { k: v for k, v in match.groupdict().items() if v is not None }

def build_version(version):
    result = f"{version['major']}.{version['minor']}.{version['patch']}"

    if "trackid" in version:
        result += f"-{version['trackid']}"

    if "track" in version:
        result += f".{version['track']}"

    if "trail" in version:
        result += version["trail"]

    return result


def bump_version(version, key):
    v = parse_version(version)

    if key not in v:
        raise ValueError(f"Invalid bump \"{key}\" for version {version}")

    v[key] = str(int(v[key]) + 1)

    reset_order = ["major", "minor", "patch", "track"]
    first_reset = reset_order.index(key) + 1

    for r in reset_order[first_reset:]:
        if r in v:
            v[r] = "0"

    return build_version(v)

if __name__ == "__main__":
    main()
