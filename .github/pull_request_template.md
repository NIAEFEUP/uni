Closes #[issue number]
<!--
Description of the changes proposed in the pull request. 
Include steps to replicate the behavior and screenshots if UI is updated.
> If this is release PR select it's template by adding ?template=release_pr_template.md to the url.
-->

# Review checklist

## View Changes

- [ ] Description has screenshots of the UI changes.
- [ ] Tested both in light and dark mode.
- [ ] New text is both in portuguese (PT) and english (EN).
- [ ] Works in different text zoom levels.
- [ ] Works in different screen sizes.

## Performance

- [ ] No helper functions to return widgets are added. New widgets are created instead.
- [ ] Used ListView.builder for Long Lists.
- [ ] Controllers (TextEditingController, ...) are beeing  disposed of in dispose() method.