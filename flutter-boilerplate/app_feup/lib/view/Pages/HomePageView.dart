import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/redux/actionCreators.dart';

class HomePageView extends StatelessWidget {
  HomePageView({Key key, @required this.title}) : super(key: key);

  final String title;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  /*********** MAIN BUILD METHOD ***********/
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text(title),
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                createAuthForm(_formKey),
                createActionButton(context)
              ]
            )));
  }

  Widget createAuthForm(key) {
    return new Form(
      key: key,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          )
        ],
      ),
    );
  }

  dynamic createActionButton(BuildContext context) {
    return new StoreConnector<AppState, Function>(
        converter: (store) => () => submitAuth(store),
        builder: (context, callback) {
          return new RaisedButton(
            onPressed: () => callback(),
            child: new Text('Submit'),
          );
        });
  }

  void submitAuth(store) {
    //validate form before submiting
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    debugPrint('user: $username | password: $password');
    store.dispatch(login(username, password));
  }

  /* Widget createCounterDisplay(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'This is a dummy text',
            style: Theme.of(context).textTheme.body1,
          ),
        ],
      ),
    );
  } */
}
