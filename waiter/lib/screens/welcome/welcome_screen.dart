import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:waiter/screens/authentication/singup_screen.dart';
import 'package:waiter/screens/authentication/signin_screen.dart';
import 'package:waiter/services/auth.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    Key? key,
    required this.auth,
  }) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Center(
            child: Text(
              "Welcome to Ordery App",
              maxLines: 2,
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          const Center(
            child: Text(
              "Order Food Smartly &\nPaperless...",
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          Lottie.asset("assets/animations/welcome-animation.json"),
          const SizedBox(height: 20.0),
          WelcomeScreenButton(
            buttonText: "Login",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInScreen(auth: auth),
                ),
              );
            },
          ),
          const SizedBox(height: 20.0),
          WelcomeScreenButton(
            buttonText: "Register",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpScreen(auth: auth),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class WelcomeScreenButton extends StatelessWidget {
  const WelcomeScreenButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);
  final String buttonText;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        width: size.width * 0.90,
        height: 55.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: const LinearGradient(
            colors: <Color>[
              Color(0xFF73A0F4),
              Color(0xFF4A47F5),
            ],
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(72, 76, 82, 0.16),
              offset: Offset(0, 12),
              blurRadius: 16.0,
            )
          ],
        ),
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 22.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
