# uni_ui

This package contains UI components (_widgets_) for the Uni app.

Widgets in this package should only display data, and not care about business
logic (which belongs to the core `uni_app` package).

Try to keep dependencies to the minimum. In ideal world, this package should
depend only on the `flutter` package. If necessary though, bring in only
dependencies that are purely UI-focused.
