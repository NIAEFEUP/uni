import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/print_provider.dart';
import 'package:uni/model/providers/session_provider.dart';
import 'package:uni/view/common_widgets/toast_message.dart';

class LoginPrintService extends StatefulWidget {
  const LoginPrintService({Key? key}) : super(key: key);

  @override
  State<LoginPrintService> createState() => _LoginPrintService();
}

class _LoginPrintService extends State<LoginPrintService> {
  static final FocusNode passwordFocus = FocusNode();
  static final TextEditingController emailController =
      TextEditingController();
  static final TextEditingController passwordController =
      TextEditingController();
  bool _obscurePasswordInput = true;
  bool _keepSignedIn = true;

  _toggleObscurePasswordInput() {
    setState(() {
      _obscurePasswordInput = !_obscurePasswordInput;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String studentNumber =
        Provider.of<SessionProvider>(context, listen: false)
            .session
            .studentNumber;
    final String email = 'up$studentNumber@up.pt';
    emailController.text = email;

    return AlertDialog(
      title: Text('PaperCut: Iniciar Sessão',
          style: Theme.of(context).textTheme.headlineSmall),
      content: SingleChildScrollView(
        child: Wrap(
          runSpacing: 10,
          children: <Widget>[
            TextFormField(
                controller: emailController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Email institucional',
                  labelStyle: Theme.of(context).textTheme.titleMedium,
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
                    labelStyle: Theme.of(context).textTheme.titleMedium,
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
                    : null),
            CheckboxListTile(
              value: _keepSignedIn,
              onChanged: (bool? value) {
                setState(() {
                  _keepSignedIn = value!;
                });
              },
              title: const Text('Manter sessão iniciada'),
              contentPadding: EdgeInsets.zero,
            ), //margin top 10
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
          onPressed: () => loginIntoPrintService(context),
        ),
      ],
    );
  }

  void loginIntoPrintService(BuildContext context) async {
    final bool response =
        await Provider.of<PrintProvider>(context, listen: false)
            .loginIntoPrintService(emailController.text, passwordController.text, false);

    if (!mounted) return;

    if (response) {
      Navigator.of(context).pop(false);
      passwordController.clear();
      ToastMessage.success(context, 'Sessão iniciada com sucesso!');
    } else {
      ToastMessage.error(context, 'Credenciais inválidas');
    }
  }
}
