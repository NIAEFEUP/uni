import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:analyzer/dart/ast/ast.dart';

PluginBase createPlugin() => UniUILint();

class UniUILint extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
    NoStringLiteralsInWidgetsLint(),
      ];
}

class NoStringLiteralsInWidgetsLint extends DartLintRule {
  NoStringLiteralsInWidgetsLint() : super(code: _code);

  static const _code = LintCode(
    name: 'string_literals_lint',
    problemMessage: 'String literals are not allowed inside a widget. Please pass this value as a parameter for the widget.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addVariableDeclaration((node) {
      if (isInsideWidgetClass(node)) {
        if (isStringLiteral(node)) {
          reporter.atNode(node, code);
        }
      }
    });
  }

  bool isInsideWidgetClass(VariableDeclaration node) {
    var parent = node.thisOrAncestorOfType<ClassDeclaration>();
    if (parent == null) return false;

    final extendsClause = parent.extendsClause;
    if (extendsClause != null) {
      final superclass = extendsClause.superclass;
      print(superclass.element?.displayName == "StatelessWidget");
      return true;
      // return superclass.runtimeType == StatelessWidget ||
      //     superclass.runtimeType == StatefulWidget;
    }
    return false;
  }

  bool isStringLiteral(VariableDeclaration node) {
    final initializer = node.initializer;
    if (initializer is StringLiteral) {
      return true;
    }
    return false;
  }
}
