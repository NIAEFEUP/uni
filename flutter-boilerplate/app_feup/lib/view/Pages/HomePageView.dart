import 'package:flutter/material.dart';

class HomePageView extends StatelessWidget {
  HomePageView({Key key,
    @required this.title,
    @required this.onChanged}) : super(key: key);

  final Function onChanged;
  final String title;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(title),
      ),
      body: createAuthForm(_formKey),
    );
  }

  Widget createAuthForm(key) {
    return new Form(
      key: key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username'
            ),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password'
            ),
            obscureText: true,
          ),
          createSubmitButton()
        ],
      ),
    );
  }

  Widget createSubmitButton() {
    return Center(
      child: RaisedButton(
        onPressed: () => submitAuth(),
        child: Text('Submit'),
      )
    );
  }

  void submitAuth() {
    //validate form before submiting
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    debugPrint('user: $username | password: $password');
    onChanged(username, password);
  }

  /* Widget createCounterDisplay(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'You have pushed the button this many times:',
            style: Theme.of(context).textTheme.body1,
          ),
          new Text(
            '$value',
            style: Theme.of(context).textTheme.title.apply(color: color),
          ),
        ],
      ),
    );
  } */
}
