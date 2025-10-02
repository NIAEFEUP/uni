# Automated Release PR

This PR was automatically created by the [release draft workflow](https://github.com/niaefeup/uni/actions/workflows/release-draft.yaml).

## How does this work?

This PR acts as a draft for a new release.

**While this PR is open:**

1. All changes made to the `main` branch will be merged into this PR.
2. The predicted release version is displayed in the PR title.

**Upon merging this PR:**

1. The app's version is bumped according to the label "1.release" on the PR.
2. The app is built and deployed to the Google Play Store.

## What can I do?

As a developer, you can:

- **Approve** this PR to publish the release.
- **Merge** this PR to create a new release.
- **Close** this PR to cancel the release.

Furthermore, you can commit to the `draft-release` branch to perform any other release-related tasks, such as editing the release notes.

### :rocket: Happy releasing!
