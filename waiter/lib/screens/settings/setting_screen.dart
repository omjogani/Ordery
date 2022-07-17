import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waiter/screens/settings/components/custom_dialog.dart';
import 'package:waiter/screens/settings/full_screen_dialog.dart';
import 'package:waiter/screens/wrapper.dart';
import 'package:waiter/services/auth.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    Key? key,
    required this.auth,
  }) : super(key: key);
  final AuthBase auth;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  void signOutNotify() {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: const Text(
          "Are you sure want to Logout?",
          style: TextStyle(
            fontSize: 23.0,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              try {
                await widget.auth.signOut();
                navigateToWrapper();
              } catch (e) {
                print(e.toString());
              }
            },
            child: const Text(
              "Yes",
              style: TextStyle(
                fontSize: 23.0,
                color: Colors.green,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text(
              "No",
              style: TextStyle(fontSize: 23.0, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void navigateToWrapper() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Wrapper(auth: Auth()),
      ),
    );
  }

  Widget closeButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 35.0,
        width: 35.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black38,
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(72, 76, 82, 0.16),
              offset: Offset(0, 12),
              blurRadius: 16.0,
            )
          ],
        ),
        child: const Icon(
          Icons.close_rounded,
          color: Color(0xFFE7EEFB),
        ),
      ),
    );
  }

  void displayInformationPopUp(String data) {
    CustomShowDialog().showFullScreenDialog(
      context,
      false,
      0.00,
      0.95,
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Flexible(
                  child: Text(
                    "Ordery App",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                closeButton(),
              ],
            ),
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.0),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color.fromRGBO(72, 76, 82, 0.16),
                      offset: Offset(0, 12),
                      blurRadius: 16.0,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        left: 16.0,
                        right: 16.0,
                        bottom: 5.0,
                      ),
                      child: Text(data),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
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
                height: 47.0,
                width: MediaQuery.of(context).size.width * 0.3,
                child: const Text(
                  "Ok!",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'SF Pro Text',
                    decoration: TextDecoration.none,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 30.0),
          const NavBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  CustomSettingTile(
                    icon: const Icon(
                      Icons.book,
                      color: Colors.white,
                    ),
                    text: "View Total Orders",
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("application")
                          .doc("Data")
                          .get()
                          .then((snapshot) {
                        displayInformationPopUp(
                            "Total Orders are: ${snapshot['totalOrders']}");
                      });
                    },
                  ),
                  const SizedBox(height: 10.0),
                  CustomSettingTile(
                    icon: const Icon(
                      Icons.book,
                      color: Colors.white,
                    ),
                    text: "View Total Food Items",
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("application")
                          .doc("Data")
                          .get()
                          .then((snapshot) {
                        displayInformationPopUp(
                            "Total Menu Items are: ${snapshot['totalMenuItems']}");
                      });
                    },
                  ),
                  const SizedBox(height: 10.0),
                  CustomSettingTile(
                    icon: const Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    text: "Logout",
                    onPressed: () => signOutNotify(),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSettingTile extends StatelessWidget {
  const CustomSettingTile({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  final Icon icon;
  final String text;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black38.withOpacity(0.2),
              offset: const Offset(0, 12),
              blurRadius: 16.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  width: 42.0,
                  height: 42.0,
                  child: icon,
                ),
                const SizedBox(width: 15.0),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 30.0,
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const <Widget>[
          Icon(
            Icons.settings,
            size: 30.0,
          ),
          SizedBox(width: 10.0),
          Center(
            child: Text(
              "Settings",
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
