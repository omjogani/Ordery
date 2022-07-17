import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:waiter/models/order_model.dart';
import 'package:waiter/providers/order_provider.dart';
import 'package:waiter/screens/cart/cart_screen.dart';
import 'package:waiter/services/auth.dart';
import 'package:waiter/services/db_helper.dart';

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
  List<String> description = [
    "French Fries + Garlic Bread (2 Piece) combo",
    "French Fries combo Save 10% + 60% Additional Discount Code Applicable",
    "substance consisting essentially of protein",
    "carbohydrate, fat, and other nutrients used",
    " The absorption and utilization of food"
  ];

  List<String> name = [
    "French Fries",
    "Burger",
    "Noodles",
    "Pizza",
    "Sandwich"
  ];

  List<int> price = [129, 199, 256, 99, 169];

  List<String> image = [
    "https://firebasestorage.googleapis.com/v0/b/ordery-1e3eb.appspot.com/o/img%2FFFries.jpg?alt=media&token=5aa2216f-2238-44a1-8d28-4649732d96af",
    "https://firebasestorage.googleapis.com/v0/b/ordery-1e3eb.appspot.com/o/img%2Fburger.jpg?alt=media&token=a6e374b8-2b3a-4c69-a4d3-4fb382df1557",
    "https://firebasestorage.googleapis.com/v0/b/ordery-1e3eb.appspot.com/o/img%2Fnoodles.jpg?alt=media&token=333d3dab-3838-4f3e-8085-8a740d245ef0",
    "https://firebasestorage.googleapis.com/v0/b/ordery-1e3eb.appspot.com/o/img%2Fpizza.jpg?alt=media&token=adbdff81-6c06-453e-95fe-cb6fe03ab848",
    "https://firebasestorage.googleapis.com/v0/b/ordery-1e3eb.appspot.com/o/img%2Fsandwich.jpg?alt=media&token=26cff717-2106-459c-9ba7-339045bbbdbd"
  ];
  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<OrderProvider>(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 30.0),
          NavBar(),
          //!

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
                final int price = itemDetail['price'];
                final String photoPath = itemDetail['photoURL'];

                return MenuListCard(
                  index: index,
                  name: name,
                  description: description,
                  imagePath: photoPath,
                  price: price.toString(),
                  onPressed: () {
                    dbHelper!
                        .insert(
                      Cart(
                        id: index,
                        orderId: index.toString(),
                        name: name,
                        description: description,
                        initialPrice: price,
                        productPrice: price,
                        quantity: 1,
                        image: photoPath,
                      ),
                    )
                        .then((value) {
                      cart.addTotalPrice(double.parse(price.toString()));
                      cart.addCounter();
                      const snackBar = SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Product is added to cart'),
                        duration: Duration(seconds: 1),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }).onError((error, stackTrace) {
                      const snackBar = SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Product is already added in cart'),
                        duration: Duration(seconds: 1),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  },
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

          //!

          // Expanded(
          //   child: ListView.builder(
          //     itemCount: name.length,
          //     physics: const BouncingScrollPhysics(),
          //     itemBuilder: (context, index) {
          //       return Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: MenuListCard(
          //           index: index,
          //           name: name[index],
          //           description: description[index],
          //           imagePath: image[index],
          //           price: price[index],
          //           onPressed: () {
          //             dbHelper!
          //                 .insert(
          //               Cart(
          //                 id: index,
          //                 orderId: index.toString(),
          //                 name: name[index],
          //                 description: description[index],
          //                 initialPrice: price[index],
          //                 productPrice: price[index],
          //                 quantity: 1,
          //                 image: image[index],
          //               ),
          //             )
          //                 .then((value) {
          //               cart.addTotalPrice(
          //                   double.parse(price[index].toString()));
          //               cart.addCounter();
          //               const snackBar = SnackBar(
          //                 backgroundColor: Colors.green,
          //                 content: Text('Product is added to cart'),
          //                 duration: Duration(seconds: 1),
          //               );

          //               ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //             }).onError((error, stackTrace) {
          //               const snackBar = SnackBar(
          //                 backgroundColor: Colors.red,
          //                 content: Text('Product is already added in cart'),
          //                 duration: Duration(seconds: 1),
          //               );

          //               ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //             });
          //           },
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            "Ordery",
            style: TextStyle(
              fontSize: 35.0,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              );
            },
            child: Icon(
              Icons.shopping_basket,
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
    required this.index,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.onPressed,
  }) : super(key: key);
  final int index;
  final String imagePath;
  final String name;
  final String description;
  final String price;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
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
                  Positioned(
                    bottom: -20,
                    right: -20,
                    child: GestureDetector(
                      onTap: () => onPressed(),
                      child: const CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 15,
                    child: GestureDetector(
                      onTap: () => onPressed(),
                      child: const Text(
                        "+",
                        style: TextStyle(
                          fontSize: 35.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
