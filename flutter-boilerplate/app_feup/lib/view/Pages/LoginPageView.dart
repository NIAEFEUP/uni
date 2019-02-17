import 'package:app_feup/model/AppState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../view/Theme.dart';

class LoginPageView extends StatelessWidget {
  LoginPageView(
      {Key key,
      @required this.checkboxValue,
      @required this.setCheckboxValue,
      @required this.usernameFocus,
      @required this.passwordFocus,
      @required this.usernameController,
      @required this.passwordController,
      @required this.formKey,
      @required this.submitForm})
      : super(key: key);

  final bool checkboxValue;
  final Function setCheckboxValue;
  final Function submitForm;
  final FocusNode usernameFocus;
  final FocusNode passwordFocus;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  MediaQueryData queryData;

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: queryData.size.width/8, right: queryData.size.width/8, top: queryData.size.height/6, bottom: queryData.size.height/6),
          child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                createTitle(),
                Spacer(),
                Form(
                  key: this.formKey,
                  child: Column(children: [
                    createUsernameInput(context),
                    Padding(padding: EdgeInsets.only(bottom: queryData.size.height/35)),
                    createPasswordInput(),
                  ]),
                ),
                createSaveDataCheckBox(),
                Spacer(),
                createLogInButton(),
                Spacer(),
                createNoteLabel()
              ],
        )),
      )
    );
  }

  Widget createTitle() {
    return new ConstrainedBox(
      constraints: new BoxConstraints(
        minWidth: queryData.size.width/8,
        minHeight: queryData.size.height/6,
      ),
      child: FittedBox(
        child: Text(
          "APP\nFEUP",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w400),
        ),
        fit: BoxFit.fill
      )
    );
  }

  Widget createUsernameInput(BuildContext context) {
    return TextFormField(
      style: new TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      autofocus: false,
      controller: usernameController,
      focusNode: usernameFocus,
      onFieldSubmitted: (term) {
        usernameFocus.unfocus();
        FocusScope.of(context).requestFocus(passwordFocus);
      },
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      decoration: textFieldDecoration('número de estudante'),
      validator: (String value) =>
          value.isEmpty ? 'Preencha este campo' : null,
    );
  }

  Widget createPasswordInput() {
    return TextFormField(
        style: new TextStyle(color: Colors.white),
        autofocus: false,
        controller: passwordController,
        focusNode: passwordFocus,
        onFieldSubmitted: (term) {
          passwordFocus.unfocus();
          submitForm();
        },
        textInputAction: TextInputAction.done,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: textFieldDecoration('palavra-passe'),
        validator: (String value) =>
            value.isEmpty ? 'Preencha este campo' : null);
  }

  Widget createSaveDataCheckBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Manter sessão iniciada",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 13.0,
                fontWeight: FontWeight.w300)),
        Checkbox(value: checkboxValue, onChanged: setCheckboxValue)
      ],
    );
  }

  Widget createLogInButton() {
    return new SizedBox(
      width: queryData.size.width/2.5,
      height: queryData.size.height/16,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        onPressed: submitForm,
        color: Colors.white,
        child: Text('Entrar',
            style: TextStyle(
                color: primaryColor, fontWeight: FontWeight.w400, fontSize: 16),
            textAlign: TextAlign.center),
      ),
    );
  }

  Widget createNoteLabel() {
    return StoreConnector<AppState, String>(
        converter: (store) => store.state.content['loginMessage'],
        builder: (context, message) {
          return Text(
            message ?? '',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w100, fontSize: 14),
          );
        });
  }

  InputDecoration textFieldDecoration(String placeholder) {
    return InputDecoration(
        errorStyle: TextStyle(
          color: Colors.white70,
          ),
        hintText: placeholder,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: new UnderlineInputBorder(),
        focusedBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.white, width: 3)));
  }
}
