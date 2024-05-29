import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/fetchers/print_fetcher.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/common_widgets/toast_message.dart';

Future<void> addMoneyDialog(BuildContext context) async {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController(text: '1,00 €');

  return showDialog(
    context: context,
    builder: (context) {
      var value = 1.0;

      return StatefulBuilder(
        builder: (context, setState) {
          void onValueChange() {
            final inputValue = valueTextToNumber(controller.text);
            setState(() => value = inputValue);
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
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.indeterminate_check_box),
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
                        icon: const Icon(Icons.add_box),
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
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            actions: [
              TextButton(
                child: Text(
                  S.of(context).cancel,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                onPressed: () => generateReference(context, value),
                child: Text(S.of(context).generate_reference),
              ),
            ],
          );
        },
      );
    },
  );
}

final CurrencyTextInputFormatter formatter =
    CurrencyTextInputFormatter.currency(
  locale: 'pt-PT',
  decimalDigits: 2,
  symbol: '€ ',
);

double valueTextToNumber(String value) =>
    double.parse(value.substring(0, value.length - 2).replaceAll(',', '.'));

String numberToValueText(double number) => number.toStringAsFixed(2);

Future<void> generateReference(BuildContext context, double amount) async {
  if (amount < 1) {
    await ToastMessage.warning(context, S.of(context).min_value_reference);
    return;
  }

  final session = Provider.of<SessionProvider>(context, listen: false).state!;
  final response =
      await PrintFetcher.generatePrintMoneyReference(amount, session);

  if (response.statusCode == 200 && context.mounted) {
    Navigator.of(context).pop(false);
    await ToastMessage.success(context, S.of(context).reference_success);
  } else if (context.mounted) {
    await ToastMessage.error(context, S.of(context).some_error);
  }
}
