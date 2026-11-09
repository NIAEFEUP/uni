# uni_lint

A [`custom_lint`](https://pub.dev/packages/custom_lint) plugin with the project's own lint rules. Everything is in `lib/uni_lint.dart`. Repo-wide rules are in the [root AGENTS.md](../../AGENTS.md).

## Current rules

| Rule | What it flags | Where it's enabled |
|---|---|---|
| `no_string_literals_in_widgets` | String literals inside `StatelessWidget` / `StatefulWidget` / `State` classes (except in `main.dart`) | Declared as a dev dependency of `uni_ui`, but the rule is set to `false` in `uni_ui/analysis_options.yaml`. `uni_app` doesn't use this package. |

## Adding a rule

1. Create a class extending `DartLintRule` with a `LintCode` (snake_case `name` and a clear `problemMessage`).
2. Register the visitor in `run()` via `context.registry.add…`, and report with `reporter.atNode(node, code)`.
3. Add the rule to the list in `UniUILint.getLintRules`.
4. Enable it in the consumer's `analysis_options.yaml` under `custom_lint: rules:`. The consumer also needs `analyzer: plugins: - custom_lint`.

## Checking a rule

Run the lints in the consuming package (e.g. `packages/uni_ui`):

```bash
dart run custom_lint
```

Write a small file that should trigger the rule and check that it's reported.

## Rules for this package

- Dependencies stay minimal: only `analyzer`, `analyzer_plugin` and `custom_lint_builder`.
- Don't put app or UI code here.
