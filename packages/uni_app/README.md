## How to run

### Main requirements

This is a Flutter project, totally compatible with Android and iOS. To run it, you need to have Flutter installed on your machine. If you don't, you can follow the instructions on https://flutter.dev/docs/get-started/install.

### Generated files

We use some code generation tools to make the development process easier.
You should **always commit** the generated `.dart` files into the repository.

**JsonSerializable**, **ObjectBox** and **Mockito** use `build_runner` to generate code:

You can generate the files once by running:
```sh
flutter pub run build_runner build
```

You can also watch for changes in `.dart` files and automatically run the `build_runner` on those file changes (useful if you find yourself in need to generate code very frequently):
```sh
flutter pub run build_runner watch
```

#### JsonSerializable

(todo)

#### ObjectBox Annotations

(todo)

#### Mockito

```dart
  import 'package:mockito/annotations.dart'

  class Cat{
  }

  @GenerateNiceMocks([MockSpec<Cat>()])
  void main(){

  }
```
In this case, `build_runner` will detect that `GenerateNiceMocks` is a generator function from `mockito` and will generate code to a different file.

### Translation files

Intl package allows the internationalization of the app, currently supporting Portuguese ('pt_PT') and English ('en_EN'), by generating `.dart` files (one for each language).
The generated files maps a key to the correspondent translated string as you can see at ```generated/intl``` files.

#### How to create

1. Add the translations you want in the `.arb` files of the ```I10n``` folder.
Example:
`intl_en.arb`
```json
{
  "hello": "Hello",
  "@hello": {
    "description": "A conventional newborn greeting"
  }
}
```
`intl_pt.arb`
```json
{
  "hello": "Olá",
  "@hello": {
    "description": "Uma saudação convencional para cansados"
  }
}
```

Note:
[ARB Editor VS Code extension](https://marketplace.visualstudio.com/items?itemName=Google.arb-editor) its useful to edit `.arb` files.

2. Generate the `.dart` files by running:
```sh
dart pub global activate intl_utils 2.1.0
dart pub global run intl_utils:generate
```

#### How to use translations

Import the generated file:
```dart
import 'package:uni/generated/l10n.dart';
```

And use the translations like this:
```dart
S.of(context).hello
```
Remember to replace `hello` with the key you defined in the `.arb` files.

### Database Admin Dashboard (Optional)

You can use the ObjectBox Admin Dashboard to visualize the database schema and its content.
By default, the dashboard is available at `http://127.0.0.1:8090/` in the running emulator or device.

If you want to access the dashboard from your development machine, you can use the following command to forward the port to your computer:
```bash
adb forward tcp:8090 tcp:8090
```

### Auto Format Hook (Optional)

The project follows formating rules and so, you must commit formatted files.
You can manually format files using `dart format` or by enabling _formatting on save_ using your IDE ([VSCode or IntelliJ](https://docs.flutter.dev/tools/formatting)).
Alternatively, you can install the git pre-commit hook that formats your changed files when you make a commit.
Install the hook by writing the following command at the **root directory of the repository**:

``` bash
chmod +x pre-commit-hook.sh && ./pre-commit-hook.sh
```

If you want to remove the hook, run command from the **root directory of the repository**:

```bash
rm .git/hooks/pre-commit
```

## Project structure
(unupdated)

### Overview

For this project, we separate the code into *model, *view* and *controller*.
By making sure view-only components are clear from the rest of the code, we can assure safe reuse of widgets as well as separated testing and development.

![MVC Scheme](../../readme-src/MVC.png "MVC Scheme")

### Model
The *model* represents the entities that are used in the app, including the session, the classes, the exams. They should be generated from the controller's methods and passed to the view. The model should not contain logic, but only the data that is needed to display the information.

### View

The *view* part of the app is made of *widgets* (stateful or stateless). They each should deal with their own responsibility (display and/or gather information) and any changes to the overall app should be passed up to their parents (using callbacks) until they reach the current page's widget, where the information will be handled. If this is not possible (e.g. updated state shall be used by more than one widget subtree), a state [provider](https://pub.dev/packages/provider) should be used.

> **Note:** if a widget's responsibility includes handling information (for example, a date-picking widget that transforms the user input into a date format), it should be done within the widget itself (may or may not use methods in the controller package depending on the complexity of the code)

### Controller

The *controller* directory contains all artifacts that are not directly related to the view or the model. This includes the parsers, the networking code, the database code and the logic that handles the global state of the app.
