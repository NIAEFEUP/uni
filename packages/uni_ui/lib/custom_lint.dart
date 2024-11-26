import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:flutter/cupertino.dart';

// This is the entrypoint of our custom linter
PluginBase createPlugin() => _ExampleLinter();

/// A plugin class is used to list all the assists/lints defined by a plugin.
class _ExampleLinter extends PluginBase {
  /// We list all the custom warnings/infos/errors
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
    StringLiteralsLint(),
  ];
}

class StringLiteralsLint extends DartLintRule {
  StringLiteralsLint() : super(code: _code);


  static const _code = LintCode(
    name: 'string_literals_lint',
    problemMessage: 'There is a string literal inside a widget',
  );

  @override
  void run(
      CustomLintResolver resolver,
      ErrorReporter reporter,
      CustomLintContext context,
      ) {
    context.registry.addVariableDeclaration((node) {
      if(isInsideWidgetClass(node)){
        if(isStringLiteral(node)){
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
      return superclass.runtimeType == StatelessWidget || superclass.runtimeType == StatefulWidget;
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