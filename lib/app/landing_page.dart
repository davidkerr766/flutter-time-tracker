import 'package:flutter/material.dart';
import 'package:time_tracker/app/home_page.dart';
import 'package:time_tracker/app/sign_in/sign_in_page.dart';
import 'package:time_tracker/services/auth.dart';

class LandingPage extends StatelessWidget {
  LandingPage({@required this.auth});
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser>(
      stream: auth.onAuthStateChange,
      initialData: null,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return HomePage(
            auth: auth,
          );
        } else {
          return SignInPage(
            auth: auth,
          );
        }
      },
    );
  }
}
