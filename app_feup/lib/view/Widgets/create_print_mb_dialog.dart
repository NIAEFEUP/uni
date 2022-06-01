import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/controller/fetchers/print_fetcher.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/view/Widgets/toast_message.dart';

Future<void> addMoneyDialog(BuildContext context) async {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller =
      TextEditingController(text: '1,00 €');

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        double value = 1.00;
        double iva = calculateIva(value);
        double total = value - iva;

        return StatefulBuilder(builder: (context, setState) {
          void _onValueChange() {
            final inputValue = valueTextToNumber(_controller.text);
            setState(() {
              value = inputValue;
              iva = calculateIva(value);
              total = inputValue - iva;
            });
          }

          _controller.addListener(_onValueChange);

          return AlertDialog(
            content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      IconButton(
                        icon: Icon(Icons.indeterminate_check_box),
                        tooltip: 'Decrementar 1,00€',
                        onPressed: () {
                          final decreasedValue =
                              valueTextToNumber(_controller.text) - 1;
                          if (decreasedValue < 1) return;

                          _controller.value = TextEditingValue(
                              text: numberToValueText(decreasedValue));
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: TextFormField(
                            controller: _controller,
                            inputFormatters: [formatter],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).focusColor))),
                            onTap: () {
                              _controller.value = TextEditingValue(
                                  text: '',
                                  selection:
                                      TextSelection.collapsed(offset: 0));
                            },
                            onChanged: (string) {
                              _controller.value = TextEditingValue(
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
                          _controller.value = TextEditingValue(
                              text: numberToValueText(
                                  valueTextToNumber(_controller.text) + 1));
                        },
                      )
                    ]),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('IVA:',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.subtitle2),
                          Text(numberToValueText(iva),
                              style: Theme.of(context).textTheme.bodyText2),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Crédito a adicionar: ',
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.subtitle2),
                            Text(numberToValueText(total),
                                style: Theme.of(context).textTheme.bodyText2),
                          ]),
                    ),
                    ElevatedButton(
                      onPressed: () => generateReference(context, value),
                      child: Text('Gerar referência'),
                    )
                  ],
                )),
            title: Text('Adicionar quota'),
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

double calculateIva(double number) {
  final value = number * 0.186; //O VALOR MÁGICO é 0.186
  return ((value * 100).round().toDouble() / 100);
}

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
