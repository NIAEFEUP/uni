import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uni/controller/fetchers/print_fetcher.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/view/widgets/toast_message.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/theme.dart';

final moneyValueProvider = StateProvider<double>((ref) => 1.0);

Future<void> addMoneyDialog(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController(text: '1,00 €');

  return showDialog(
    context: context,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          final value = ref.watch(moneyValueProvider);

          void onValueChange() {
            final inputValue = valueTextToNumber(controller.text);
            ref.read(moneyValueProvider.notifier).state = inputValue;
          }

          controller.addListener(onValueChange);

          return AlertDialog(
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                    child: Text(
                      S.of(context).reference_sigarra_help,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).titleSmall,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.indeterminate_check_box), // use uni_ui icons instead
                        tooltip: S.of(context).decrement,
                        onPressed: () {
                          final decreasedValue =
                              valueTextToNumber(controller.text) - 1;
                          if (decreasedValue < 1) {
                            return;
                          }

                          controller.value = TextEditingValue(
                            text: numberToValueText(decreasedValue),
                          );
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10,
                          ),
                          child: TextFormField(
                            controller: controller,
                            inputFormatters: [formatter],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            onTap: () {
                              controller.value = const TextEditingValue(
                                selection: TextSelection.collapsed(offset: 0),
                              );
                            },
                            onChanged: (string) {
                              controller.value = TextEditingValue(
                                text: string,
                                selection: TextSelection.collapsed(
                                  offset: string.length,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_box), // use uni_ui icons instead
                        tooltip: S.of(context).increment,
                        onPressed: () {
                          controller.value = TextEditingValue(
                            text: numberToValueText(
                              valueTextToNumber(controller.text) + 1,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            title: Text(
              S.of(context).add_quota,
              style: Theme.of(context).headlineSmall,
            ),
            actions: [
              TextButton(
                child: Text(
                  S.of(context).cancel,
                  style: Theme.of(context).bodyMedium,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                onPressed: () => generateReference(context, ref, value),
                child: Text(S.of(context).generate_reference),
              ),
            ],
          );
        },
      );
    },
  );
}

final formatter = CurrencyTextInputFormatter.currency(
  locale: 'pt',
  decimalDigits: 2,
  symbol: '€ ',
);

double valueTextToNumber(String value) =>
    double.parse(value.substring(0, value.length - 2).replaceAll(',', '.'));

String numberToValueText(double number) => number.toStringAsFixed(2);

Future<void> generateReference(
  BuildContext context,
  WidgetRef ref,
  double amount,
) async {
  if (amount < 1) {
    await ToastMessage.warning(context, S.of(context).min_value_reference);
    return;
  }

  final session = ref.read(sessionProvider.select((value) => value.value!));
  final response = await PrintFetcher.generatePrintMoneyReference(
    amount,
    session,
  );

  if (response.statusCode == 200 && context.mounted) {
    Navigator.of(context).pop(false);
    await ToastMessage.success(context, S.of(context).reference_success);
  } else if (context.mounted) {
    await ToastMessage.error(context, S.of(context).some_error);
  }
}
