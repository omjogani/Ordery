import 'dart:math';
import 'package:admin/constant.dart';
import 'package:admin/screens/splash/components/splashscreen.dart';
import 'package:admin/screens/wrapper.dart';
import 'package:admin/services/auth.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    List<Color> currentSelectedGradient = kBackgroundColorSplash;
    return SplashScreen(
      title: const Text(
        "Ordery Admin App",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 28.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      seconds: 3,
      shadowColor: currentSelectedGradient.first,
      gradientBackground: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: currentSelectedGradient,
      ),
      image: Image.asset(
        "assets/images/logo.png",
      ),
      styleTextUnderTheLoader: const TextStyle(),
      photoSize: 100,
      loaderColor: Colors.white,
      loadingText: const Text(
        "Loading...",
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
      navigateAfterSeconds: Wrapper(
        auth: Auth(),
      ),
    );
  }
}
