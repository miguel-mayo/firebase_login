import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/services/email_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  EmailService _emailService;

  _navigationHandling() {
    _emailService.authChanges.listen((event) {
      if (event == null)
        Navigator.of(context).pushNamedAndRemoveUntil('/splash', (route) => false);
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "You are logged in!",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.redAccent),
            ),
            SizedBox(height: 16),
            Text(
              "${widget.user.email}",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.black),
            ),
            SizedBox(height: 32),
            FlatButton(onPressed: _logout, child: Text("Log out"))
          ],
        ),
      ),
    );
  }

  _logout() async {
    await _emailService.signOut();
  }
}
