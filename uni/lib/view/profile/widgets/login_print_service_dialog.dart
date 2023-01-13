import 'package:flutter/material.dart';

class LoginPrintService extends StatefulWidget {
  const LoginPrintService({super.key});

  @override
  State<LoginPrintService> createState() => _LoginPrintService();
}

class _LoginPrintService extends State<LoginPrintService> {
  static final FocusNode passwordFocus = FocusNode();
  static final TextEditingController passwordController =
      TextEditingController();
  bool _obscurePasswordInput = true;

  _toggleObscurePasswordInput() {
    setState(() {
      _obscurePasswordInput = !_obscurePasswordInput;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('PaperCut: Iniciar Sessão',
          style: Theme.of(context).textTheme.headline5),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextFormField(
                initialValue: 'up20210884@up.pt',
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Email institucional',
                  labelStyle: Theme.of(context).textTheme.subtitle1,
                )),
            TextFormField(
                enableSuggestions: false,
                autocorrect: false,
                controller: passwordController,
                focusNode: passwordFocus,
                onFieldSubmitted: (term) {
                  passwordFocus.unfocus();
                },
                textInputAction: TextInputAction.done,
                obscureText: _obscurePasswordInput,
                decoration: InputDecoration(
                    labelText: 'Palavra-passe',
                    labelStyle: Theme.of(context).textTheme.subtitle1,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePasswordInput
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: _toggleObscurePasswordInput,
                    )),
                validator: (String? value) => value != null && value.isEmpty
                    ? 'Preenche este campo'
                    : null)
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            passwordFocus.unfocus();
            passwordController.clear();
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Iniciar Sessão'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
