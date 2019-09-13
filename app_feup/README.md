# app_feup

A new Flutter project.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).


## Requirements

In order to submit bug reports to the Github API, a Github Personal Access Token is required.
If you don't have one, you can create it on https://github.com/settings/tokens. The only permission it needs is **repo > public_repo**.

The token is read from the file ```assets/env/env.json```, which you may need to create, and must be in the following format:

```json
{
  "gh_token" : "your super secret token"
}
```