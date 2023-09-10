## How to run

### Main requirements

This is a Flutter project, totally compatible with Android and iOS. To run it, you need to have Flutter installed on your machine. If you don't, you can follow the instructions on https://flutter.dev/docs/get-started/install.

### Further requirements

In order to submit bug reports to the Github API (needed in order to enable in-app bug reporting), a Github Personal Access Token is required. If you don't have one, you can create it on https://github.com/settings/tokens. The only permission it needs is **repo > public_repo**.

The token is read from the file assets/env/env.json, which you may need to create, and must be in the following format:

```json
{
  "gh_token" : "your super secret token"
}
```

### Automated formatting

In order to contribute, you must format your changed files using `dart format` manually or enabing _formatting on save_ using your IDE ([VSCode or IntelliJ](https://docs.flutter.dev/tools/formatting)). Alternatively, you can install the git pre-commit hook that formats your changed files when you commit, doing the following command at the **root directory of the repository**:

``` bash
  chmod +x pre-commit-hook.sh && ./pre-commit-hook.sh
```

In order to remove it, is it as simple as running the following command, from the **root directory of the repository**:

```bash
 rm .git/hooks/pre-commit
```

### Generated files

Flutter doesn't support runtime reflection. In order to circumvent these limitations, we use **automatic code generation** or **static metaprogramming** for things like **mocks** and other possible usecases. By convention, you should **always commit** the generated `.dart` files into the repository. 

Dart leverages annotations to signal the `build_runner` that it should generate some code. They look something like this:
```dart
  import 'package:mockito/annotations.dart'

  class Cat{
  }

  @GenerateNiceMocks([MockSpec<Cat>()])
  void main(){

  }
```
In this case, `build_runner` will detect that `GenerateNiceMocks` is a generator function from `mockito` and will generate code to a different file.

In order to run the `build_runner` once:
```sh
dart run build_runner build
```

But you can also watch for changes in `.dart` files and automatically run the `build_runner` on those file changes (useful if you find yourself in need to generate code very frequently):
```sh
dart run build_runner watch
```

## Project structure

### Overview

For this project, we separate the code into *model, *view* and *controller*.
By making sure view-only components are clear from the rest of the code, we can assure safe reuse of widgets as well as separated testing and development.

![MVC Scheme](../readme-src/MVC.png "MVC Scheme")

### Model
The *model* represents the entities that are used in the app, including the session, the classes, the exams. They should be generated from the controller's methods and passed to the view. The model should not contain logic, but only the data that is needed to display the information.

### View

The *view* part of the app is made of *widgets* (stateful or stateless). They each should deal with their own responsibility (display and/or gather information) and any changes to the overall app should be passed up to their parents (using callbacks) until they reach the current page's widget, where the information will be handled. If this is not possible (e.g. updated state shall be used by more than one widget subtree), a state [provider](https://pub.dev/packages/provider) should be used.

> **Note:** if a widget's responsibility includes handling information (for example, a date-picking widget that transforms the user input into a date format), it should be done within the widget itself (may or may not use methods in the controller package depending on the complexity of the code)

### Controller

The *controller* directory contains all artifacts that are not directly related to the view or the model. This includes the parsers, the networking code, the database code and the logic that handles the global state of the app.
