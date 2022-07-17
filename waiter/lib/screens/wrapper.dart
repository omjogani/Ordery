import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waiter/screens/authentication/singup_screen.dart';
import 'package:waiter/screens/home/bottom_navigation_bar_wrapper.dart';
import 'package:waiter/screens/home/home_screen.dart';
import 'package:waiter/screens/welcome/welcome_screen.dart';
import 'package:waiter/services/auth.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({
    Key? key,
    required this.auth,
  }) : super(key: key);
  final AuthBase auth;
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: widget.auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            // return AuthenticationScreen(auth: widget.auth);
            return WelcomeScreen(auth: widget.auth);
          }
          return BottomNavigationWrapper(auth: widget.auth);
          // return HomeScreen(auth: widget.auth);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
