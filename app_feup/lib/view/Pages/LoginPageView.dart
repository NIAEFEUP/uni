import 'package:app_feup/model/AppState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toast/toast.dart';
import '../../view/Theme.dart';
<<<<<<< HEAD
import '../Widgets/BackButtonExitWrapper.dart';
=======
import 'dart:async';
>>>>>>> Changed onWillPop to use Future.delayed

bool exitApp = false;

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
    final MediaQueryData queryData = MediaQuery.of(context);

    return new Scaffold(
      backgroundColor: primaryColor,
      body: WillPopScope(
        child: Padding(
          padding: EdgeInsets.only(
            left: queryData.size.width / 8,
            right: queryData.size.width / 8),
          child: new ListView(
            children: getWidgets(context, queryData),
          )
        ), onWillPop: () => onWillPop(context))

    );
  }

  List<Widget> getWidgets(BuildContext context, MediaQueryData queryData){
    List<Widget> widgets = new List();

    widgets.add(Padding(padding: EdgeInsets.only(bottom: queryData.size.height/20)));
    widgets.add(createTitle(queryData, context));
    widgets.add(Padding(padding: EdgeInsets.only(bottom: queryData.size.height/35)));
    widgets.add(getLoginForm(queryData, context));
    widgets.add(Padding(padding: EdgeInsets.only(bottom: queryData.size.height/35)));
    widgets.add(createSaveDataCheckBox());
    widgets.add(Padding(padding: EdgeInsets.only(bottom: queryData.size.height/15)));
    widgets.add(createLogInButton(queryData));
    widgets.add(Padding(padding: EdgeInsets.only(bottom: queryData.size.height/35)));
    widgets.add(createStatusWidget(context));
    widgets.add(Padding(padding: EdgeInsets.only(bottom: queryData.size.height/10)));

    return widgets;
  }

  void displayToastMessage(BuildContext context, String msg) {
    Toast.show(
      msg,
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
      backgroundColor: toastColor,
      backgroundRadius: 16.0,
      textColor: Colors.white,
    );
  }

  Future<void> exitAppWaiter() async{
    exitApp = true;
    await new Future.delayed(Duration(seconds: Toast.LENGTH_LONG));
    exitApp = false;
  }

  Future<bool> onWillPop(BuildContext context) {
    if(exitApp){
      return Future.value(true);
    }
    displayToastMessage(context, 'Pressione novamente para sair');
    exitAppWaiter();
    return Future.value(false);
  }

  Widget createTitle(queryData, context) {
    return new ConstrainedBox(
        constraints: new BoxConstraints(
          minWidth: queryData.size.width/8,
          minHeight: queryData.size.height/6,
        ),
        child:
        Column(children:[
          SizedBox(
            child: SvgPicture.asset(
              'assets/images/logo_dark.svg',
              color: Colors.white,
            ),
            width: 100.0
          ),
        ])
    );
  }

  Widget getLoginForm(MediaQueryData queryData, BuildContext context){
    return new Form(
      key: this.formKey,
      child: Column(children: [
        createUsernameInput(context),
        Padding(
            padding: EdgeInsets.only(
                bottom: queryData.size.height / 35)),
        createPasswordInput(),
      ]),
    );
  }

  Widget createUsernameInput(BuildContext context) {
    return TextFormField(
      style: new TextStyle(color: Colors.white, fontSize: 20),
      keyboardType: TextInputType.text,
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
      validator: (String value) => value.isEmpty ? 'Preencha este campo' : null,
    );
  }

  Widget createPasswordInput() {
    return TextFormField(
        style: new TextStyle(color: Colors.white, fontSize: 20),
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
                fontSize: 17.0,
                fontWeight: FontWeight.w300)),
        Checkbox(value: checkboxValue, onChanged: setCheckboxValue)
      ],
    );
  }

  Widget createLogInButton(queryData) {
    return new Padding(
      padding: EdgeInsets.only(
        left: queryData.size.width / 7,
        right: queryData.size.width / 7),
      child: SizedBox(
        height: queryData.size.height / 16,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          onPressed: submitForm,
          color: Colors.white,
          child: Text('Entrar',
              style: TextStyle(
                  color: primaryColor, fontWeight: FontWeight.w400, fontSize: 20),
              textAlign: TextAlign.center),
        ),
      ),
    );
  }

  Widget createStatusWidget(BuildContext context) {
    return StoreConnector<AppState, RequestStatus>(
        converter: (store) => store.state.content['loginStatus'],
        onWillChange: (status) {
          if (status == RequestStatus.SUCCESSFUL)
            Navigator.pushReplacementNamed(context, '/Área Pessoal');
          else if(status == RequestStatus.FAILED)
            displayToastMessage(context, 'O login falhou');
        },
        builder: (context, status) {
          switch (status) {
            case RequestStatus.BUSY:
              return new Container(
                height: 60.0,
                child: new Center(child: new CircularProgressIndicator()),
              );
            default:
              return Container();
          }
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
