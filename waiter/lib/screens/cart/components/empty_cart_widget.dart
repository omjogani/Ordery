import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyCartWidget extends StatefulWidget {
  const EmptyCartWidget({Key? key}) : super(key: key);

  @override
  _EmptyCartWidgetState createState() => _EmptyCartWidgetState();
}

class _EmptyCartWidgetState extends State<EmptyCartWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Lottie.asset("assets/animations/empty-cart.json"),
          const Text(
            "Your Cart is Empty!!",
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: 25.0,
            ),
          ),
          const Text(
            "Ordery App",
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }
}
