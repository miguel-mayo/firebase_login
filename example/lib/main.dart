import 'dart:async';

import 'package:example/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_login/services/email_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/splash': (context) =>
            SplashPage(title: 'Firebase login Demo Home Page'),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _flutterFireInit(),
    );
  }

  _flutterFireInit() {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return ErrorView(error: "Error: ${snapshot.error}");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return SplashPage(title: 'Firebase login Demo Home Page');
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return LoadingView();
      },
    );
  }
}

class SplashPage extends StatefulWidget {
  SplashPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  EmailService _emailService;

  final _emailController = BehaviorSubject<String>();

  final _passwordController = BehaviorSubject<String>();

  bool registerView = true;

  String get titleText => registerView
      ? 'Register with email and password'
      : 'Sign in with email and password';

  @override
  void dispose() {
    super.dispose();
    _emailController.close();
    _passwordController.close();
  }

  _navigationHandling() {
    _emailService.authChanges.listen((event) {
      if (event != null)
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Home(user: event)));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _emailService = EmailService();
    _navigationHandling();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          registerView
              ? IconButton(
                  icon: Icon(Icons.login),
                  onPressed: () => setState(() => registerView = false))
              : IconButton(
                  icon: Icon(Icons.create_outlined),
                  onPressed: () => setState(() => registerView = true))
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  titleText,
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 8,
                ),
                Card(
                  color: Colors.grey.shade300,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          onChanged: _emailController.sink.add,
                          decoration: InputDecoration(hintText: "Email"),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          onChanged: _passwordController.sink.add,
                          decoration: InputDecoration(hintText: "Password"),
                        ),
                        SizedBox(height: 8),
                        registerView ? _registerButton() : _loginButton()
                      ],
                    ),
                  ),
                ),
                Expanded(child: SizedBox()),
                Text(
                  "Send reset pass email",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 8,
                ),
                Card(
                  color: Colors.grey.shade300,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          onChanged: _emailController.sink.add,
                          decoration: InputDecoration(hintText: "Email"),
                        ),
                        _resetButton()
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 32,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _registerButton() {
    return RaisedButton(
      onPressed: _register,
      color: Colors.amber,
      child: Text("Registrar"),
    );
  }

  _loginButton() {
    return RaisedButton(
      onPressed: _login,
      color: Colors.cyan,
      child: Text("Login"),
    );
  }

  _resetButton() {
    return FlatButton(
        onPressed: _forgotPassword,
        child: Text(
          "Forgot password",
          style: TextStyle(decoration: TextDecoration.underline),
        ));
  }

  _register() async {
    print("Register");

    final email = _emailController.value;
    final password = _passwordController.value;

    final user = await _emailService
        .registerWithEmailAndPassword(email, password)
        .catchError((err) => _showDialog("ERROR!!! --> $err"));
    print(user);
  }

  _login() async {
    print("Register");

    final email = _emailController.value;
    final password = _passwordController.value;

    final user = await _emailService
        .signInWithEmailAndPassword(email, password)
        .catchError((err) => _showDialog("ERROR!!! --> $err"));
    print(user);
  }

  _forgotPassword() async {
    print("Register");

    final email = _emailController.value;

    await _emailService
        .resetPassword(email)
        .catchError((err) => _showDialog("ERROR!!! --> $err"));
    _showDialog("Email sended!");
  }

  _showDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¡Vaya, hubo un error!"),
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({Key key, this.error}) : super(key: key);
  final String error;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(error),
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
