import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:uni/controller/networking/network_router.dart';

Future<void> addMoneyDialog(BuildContext context) async {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller =
      TextEditingController(text: '1,00 €');

  final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'pt-PT', decimalDigits: 2, symbol: '€ ');

  double valueTextToNumber(String value) =>
      double.parse(value.substring(0, value.length - 2).replaceAll(',', '.'));
  String numberToValueText(double number) =>
      formatter.format(number.toStringAsFixed(2));

  generateReference(context, amount) async {
    final response = await NetworkRouter.generatePrintMoneyReference(amount);
    Navigator.of(context).pop(false);
  }

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        //State
        double value = 1.00;
        double iva = value * 0.19;
        double total = value - iva;

        return StatefulBuilder(builder: (context, setState) {
          void _onValueChange() {
            final inputValue = valueTextToNumber(_controller.text);
            setState(() {
              value = inputValue;
              iva = (inputValue * 0.19);
              total = inputValue * 0.81;
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
                                          color:
                                              Theme.of(context).accentColor))),
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
                              }),
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
                          Text('IVA 23%:',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.headline2),
                          Text(numberToValueText(iva),
                              style: Theme.of(context).textTheme.headline3),
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
                                style: Theme.of(context).textTheme.headline2),
                            Text(numberToValueText(total),
                                style: Theme.of(context).textTheme.headline3),
                          ]),
                    ),
                    ElevatedButton(
                      onPressed: () => generateReference(context, value),
                      child: Text('Gerar Refêrencia'),
                    )
                  ],
                )),
            title: Text('Adicionar quota'),
          );
        });
      });
}
