
import 'package:flutter/material.dart';

class FullScreenDialog extends StatelessWidget {
  const FullScreenDialog({
    Key? key,
    required this.child,
    required this.height,
    required this.width,
    required this.isHeighted,
  }) : super(key: key);
  final Widget child;
  final double height;
  final double width;
  final bool isHeighted;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        backgroundColor: Color(0xFFE7EEFB),
        elevation: 0.0,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -50.0,
              left: -50.0,
              child: Container(
                height: 200.0,
                width: 200.0,
                decoration: BoxDecoration(
                    gradient: RadialGradient(
                  colors: <Color>[
                    Color(0xFF4e5bb1).withOpacity(0.3),
                    Color(0xFF4e5bb1).withOpacity(0.2),
                    Color(0xFF4e5bb1).withOpacity(0.1),
                    Color(0xFF4e5bb1).withOpacity(0.01),
                  ],
                )),
              ),
            ),
            
            SizedBox(
              height: isHeighted ? size.height * height : null,
              width: size.width * width,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
