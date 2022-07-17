import 'package:admin/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.auth,
  }) : super(key: key);
  final AuthBase auth;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String totalOrders = " ";
  String totalMenuItem = " ";

  @override
  void initState() {
    loadDataFromFirebase();
    super.initState();
  }

  void loadDataFromFirebase() {
    try {
      FirebaseFirestore.instance
          .collection("application")
          .doc("Data")
          .get()
          .then((snapshot) {
        setState(() {
          totalOrders = snapshot['totalOrders'].toString();
          totalMenuItem = snapshot['totalMenuItems'].toString();
        });
      });
    } catch (e) {
      final snackBar = SnackBar(content: Text("ERROR: $e"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 30.0),
          const NavBar(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 12.0, left: 12.0, bottom: 12.0, right: 12.0),
                  child: totalOrders == " "
                      ? const Center(child: CupertinoActivityIndicator())
                      : mainBox(size, "Total\nOrders", totalOrders),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: totalMenuItem == " "
                      ? const Center(child: CupertinoActivityIndicator())
                      : mainBox(size, "Total\nMenu", totalMenuItem),
                ),
              ),
            ],
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('menu')
                .doc("Data")
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.data == null) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      CupertinoActivityIndicator(),
                      Text(
                        "Fetching Data...",
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                );
              }

              final DocumentSnapshot document =
                  snapshot.data as DocumentSnapshot;

              final Map<String, dynamic> documentData =
                  document.data() as Map<String, dynamic>;

              List checkingForEmptyList = documentData['menu'];
              if (documentData['menu'] == null ||
                  checkingForEmptyList.isEmpty) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Lottie.asset(
                        "assets/animation/empty-cart.json",
                        height: 200.0,
                        width: 200.0,
                      ),
                      const Text(
                        "No Menu Available",
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                );
              }

              final List<Map<String, dynamic>> itemDetailList =
                  (documentData['menu'] as List)
                      .map((itemDetail) => itemDetail as Map<String, dynamic>)
                      .toList();
              var itemDetailsListReversed = itemDetailList.reversed.toList();

              _buildListTileHere(int index) {
                final Map<String, dynamic> itemDetail =
                    itemDetailsListReversed[index];
                final String name = itemDetail['name'];
                final String description = itemDetail['description'];
                final String price = itemDetail['price'].toString();
                final String photoPath = itemDetail['photoURL'];

                return MenuListCard(
                  name: name,
                  description: description,
                  imagePath: photoPath,
                  onPressed: () {},
                  price: price,
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: itemDetailsListReversed.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildListTileHere(index);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget mainBox(Size size, String title, String value) {
  return Container(
    height: size.height * 0.25,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.white,
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color.fromRGBO(72, 76, 82, 0.16),
          offset: Offset(0, 12),
          blurRadius: 16.0,
        )
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 25.0,
          ),
        ),
        const SizedBox(height: 20.0),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 35.0,
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const <Widget>[
          Text(
            "Ordery Statistics",
            style: TextStyle(
              fontSize: 35.0,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuListCard extends StatelessWidget {
  const MenuListCard({
    Key? key,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.onPressed,
  }) : super(key: key);
  final String imagePath;
  final String name;
  final String description;
  final String price;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Container(
        width: size.width * 96,
        height: size.height * 0.18,
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
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, bottom: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: SizedBox(
                    height: size.height * 0.17,
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: size.height * 0.18,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 5.0),
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 22.0,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "\u20B9$price",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 22.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
