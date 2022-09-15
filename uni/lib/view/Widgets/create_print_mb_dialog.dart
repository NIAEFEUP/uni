import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/controller/fetchers/print_fetcher.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/view/Widgets/toast_message.dart';

Future<void> addMoneyDialog(BuildContext context) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller =
      TextEditingController(text: '1,00 €');

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        double value = 1.00;

        return StatefulBuilder(builder: (context, setState) {
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
                            'Os dados da referência gerada aparecerão no Sigarra, conta corrente. \nPerfil > Conta Corrente',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.subtitle2)),
                    Row(children: [
                      IconButton(
                        icon: const Icon(Icons.indeterminate_check_box),
                        tooltip: 'Decrementar 1,00€',
                        onPressed: () {
                          final decreasedValue =
                              valueTextToNumber(controller.text) - 1;
                          if (decreasedValue < 1) return;

                          controller.value = TextEditingValue(
                              text: numberToValueText(decreasedValue));
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          child: TextFormField(
                            controller: controller,
                            inputFormatters: [formatter],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            onTap: () {
                              controller.value = const TextEditingValue(
                                  text: '',
                                  selection:
                                      TextSelection.collapsed(offset: 0));
                            },
                            onChanged: (string) {
                              controller.value = TextEditingValue(
                                  text: string,
                                  selection: TextSelection.collapsed(
                                      offset: string.length));
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_box),
                        tooltip: 'Incrementar 1,00€',
                        onPressed: () {
                          controller.value = TextEditingValue(
                              text: numberToValueText(
                                  valueTextToNumber(controller.text) + 1));
                        },
                      )
                    ])
                  ],
                )),
            title: Text('Adicionar quota',
                style: Theme.of(context).textTheme.headline5),
            actions: [
              TextButton(
                  child: Text('Cancelar',
                      style: Theme.of(context).textTheme.bodyText2),
                  onPressed: () => Navigator.pop(context)),
              ElevatedButton(
                onPressed: () => generateReference(context, value),
                child: const Text('Gerar referência'),
              )
            ],
          );
        });
      });
}

final CurrencyTextInputFormatter formatter =
    CurrencyTextInputFormatter(locale: 'pt-PT', decimalDigits: 2, symbol: '€ ');
double valueTextToNumber(String value) =>
    double.parse(value.substring(0, value.length - 2).replaceAll(',', '.'));
String numberToValueText(double number) =>
    formatter.format(number.toStringAsFixed(2));

generateReference(context, amount) async {
  if (amount < 1) {
    return ToastMessage.display(context, 'Valor mínimo: 1,00 €');
  }

  final session = StoreProvider.of<AppState>(context).state.content['session'];
  final response =
      await PrintFetcher.generatePrintMoneyReference(amount, session);

  if (response.statusCode == 200) {
    Navigator.of(context).pop(false);
    ToastMessage.display(context, 'Referência criada com sucesso!');
  } else {
    ToastMessage.display(context, 'Algum erro!');
  }
}
