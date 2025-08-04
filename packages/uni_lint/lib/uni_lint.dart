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
    name: 'no_string_literals_in_widgets',
    problemMessage:
        'String literals are not allowed inside a widget. Please pass this value as a parameter for the widget.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addStringLiteral((node) {
      final fileUri =
          node
              .thisOrAncestorOfType<CompilationUnit>()
              ?.declaredFragment
              ?.source
              .uri;
      final fileName = fileUri?.pathSegments.last;
      if (isInsideWidgetClass(node) && fileName != "main.dart") {
        reporter.atNode(node, code);
      }
    });
  }

  bool isInsideWidgetClass(StringLiteral node) {
    var parent = node.thisOrAncestorOfType<ClassDeclaration>();
    if (parent == null) return false;

    final extendsClause = parent.extendsClause;
    if (extendsClause != null) {
      final superclass = extendsClause.superclass;
      return superclass.element2?.displayName == "StatelessWidget" ||
          superclass.element2?.displayName == "StatefulWidget" ||
          superclass.element2?.displayName == "State";
    }
    return false;
  }
}
