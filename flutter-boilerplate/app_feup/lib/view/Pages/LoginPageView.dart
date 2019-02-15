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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomPadding: false,
      body: Center(
          child: Padding(
        padding:
            EdgeInsets.only(left: 50.0, right: 50.0, top: 100.0, bottom: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: createTitle(),
            ),
            Expanded(
                flex: 4,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Form(
                        key: this.formKey,
                        child: Column(children: [
                          createUsernameInput(context),
                          Padding(padding: EdgeInsets.only(bottom: 20)),
                          createPasswordInput(),
                          Padding(padding: EdgeInsets.only(bottom: 5))
                        ]),
                      ),
                      createSaveDataCheckBox()
                    ])),
            createLogInButton(),
            Padding(padding: EdgeInsets.only(bottom: 50)),
            Expanded(flex: 1, child: createNoteLabel()),
          ],
        ),
      )),
    );
  }

  Widget createTitle() {
    return Text(
      "APP\nFEUP",
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.w400),
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
      decoration: textFieldDecoration('student nr'),
      validator: (String value) =>
          value.isEmpty ? 'Student number can\'t be empty' : null,
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
        decoration: textFieldDecoration('password'),
        validator: (String value) =>
            value.isEmpty ? 'Password can\'t be empty' : null);
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
      width: 150,
      height: 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        onPressed: submitForm,
        padding: EdgeInsets.all(12),
        color: Colors.white,
        child: Text('Log In',
            style: TextStyle(
                color: primaryColor, fontWeight: FontWeight.w400, fontSize: 18),
            textAlign: TextAlign.center),
      ),
    );
  }

  Widget createNoteLabel() {
    return StoreConnector<AppState, String>(
        converter: (store) => store.state.content['loginMessage'],
        builder: (context, message) {
          return Text(
            message ?? 'No message',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w100),
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
