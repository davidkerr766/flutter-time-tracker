import 'package:flutter/material.dart';
import 'package:time_tracker/app/home_page.dart';
import 'package:time_tracker/app/sign_in/sign_in_page.dart';
import 'package:time_tracker/services/auth.dart';

class LandingPage extends StatefulWidget {
  LandingPage({@required this.auth});
  final AuthBase auth;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  AppUser _user;

  @override
  void initState() {
    super.initState();
    _updateUser(widget.auth.currentUser());
  }

  void _updateUser(AppUser user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return HomePage(
            auth: widget.auth,
            onSignOut: () => _updateUser(null),
          );
        } else {
          return SignInPage(
            onSignIn: _updateUser,
            auth: widget.auth,
          );
        }
      },
    );
  }
}
