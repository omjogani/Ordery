import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waiter/screens/cart/cart_screen.dart';
import 'package:waiter/screens/home/home_screen.dart';
import 'package:waiter/screens/settings/setting_screen.dart';
import 'package:waiter/services/auth.dart';

class BottomNavigationWrapper extends StatefulWidget {
  const BottomNavigationWrapper({
    Key? key,
    required this.auth,
  }) : super(key: key);
  final AuthBase auth;

  @override
  _BottomNavigationWrapperState createState() =>
      _BottomNavigationWrapperState();
}

class _BottomNavigationWrapperState extends State<BottomNavigationWrapper> {
  int index = 0;
  late PageController _pageController;
  late int currentTheme = -1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> onWillPopExit(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            content: const Text(
              "Do you really want to Exit the App?",
              style: TextStyle(
                fontSize: 23.0,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(
                    fontSize: 23.0,
                    color: Colors.blue,
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
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => onWillPopExit(context),
        child: Stack(
          children: <Widget>[
            SizedBox.expand(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => this.index = index);
                },
                children: <Widget>[
                  HomeScreen(auth: widget.auth),
                  CartScreen(),
                  // OrderScreen(),
                  SettingScreen(auth: widget.auth),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  Widget buildBottomNavigation() {
    const Color activeColor = Colors.black;
    const Color inactiveColor = CupertinoColors.systemGrey;
    return BottomNavyBar(
      backgroundColor: const Color(0xFFF2F2F2),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      onItemSelected: (index) {
        setState(() {
          this.index = index;
        });
        _pageController.jumpToPage(index);
      },
      selectedIndex: index,
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: const Icon(CupertinoIcons.home),
          title: const Text("Home"),
          textAlign: TextAlign.center,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.shopping_basket_rounded),
          title: const Text("Cart"),
          textAlign: TextAlign.center,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
        // BottomNavyBarItem(
        //   icon: const Icon(Icons.book),
        //   title: const Text("Orders"),
        //   textAlign: TextAlign.center,
        //   activeColor: activeColor,
        //   inactiveColor: inactiveColor,
        // ),
        BottomNavyBarItem(
          icon: const Icon(CupertinoIcons.settings),
          title: const Text("Settings"),
          textAlign: TextAlign.center,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
      ],
    );
  }
}
