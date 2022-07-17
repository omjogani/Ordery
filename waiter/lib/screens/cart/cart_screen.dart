import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiter/models/order_model.dart';
import 'package:waiter/providers/order_provider.dart';
import 'package:waiter/screens/authentication/components/input_field.dart';
import 'package:waiter/screens/cart/components/empty_cart_widget.dart';
import 'package:waiter/services/application_service.dart';
import 'package:waiter/services/db_helper.dart';
import 'package:waiter/services/order_services.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();
  final FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  late String name;
  final GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;
  bool isLoading = false;

  void decrementItem(
      AsyncSnapshot<List<Cart>> snapshot, int index, OrderProvider cart) {
    int quantity = snapshot.data![index].quantity!;
    int price = snapshot.data![index].initialPrice!;
    quantity--;
    int? newPrice = price * quantity;

    if (quantity > 0) {
      dbHelper!
          .updateQuantity(
        Cart(
          id: snapshot.data![index].id!,
          orderId: snapshot.data![index].id!.toString(),
          name: snapshot.data![index].name!,
          description: snapshot.data![index].description!,
          initialPrice: snapshot.data![index].initialPrice!,
          productPrice: newPrice,
          quantity: quantity,
          image: snapshot.data![index].image.toString(),
        ),
      )
          .then((value) {
        newPrice = 0;
        quantity = 0;
        cart.removeTotalPrice(double.parse(
          snapshot.data![index].initialPrice!.toString(),
        ));
      }).onError(
        (error, stackTrace) {
          print(error.toString());
        },
      );
    }
  }

  void incrementItem(
      AsyncSnapshot<List<Cart>> snapshot, int index, OrderProvider cart) {
    int quantity = snapshot.data![index].quantity!;
    int price = snapshot.data![index].initialPrice!;
    quantity++;
    int? newPrice = price * quantity;

    dbHelper!
        .updateQuantity(
      Cart(
        id: snapshot.data![index].id!,
        orderId: snapshot.data![index].id!.toString(),
        name: snapshot.data![index].name!,
        description: snapshot.data![index].description!,
        initialPrice: snapshot.data![index].initialPrice!,
        productPrice: newPrice,
        quantity: quantity,
        image: snapshot.data![index].image.toString(),
      ),
    )
        .then((value) {
      newPrice = 0;
      quantity = 0;
      cart.addTotalPrice(
        double.parse(
          snapshot.data![index].initialPrice!.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(
        error.toString(),
      );
    });
  }

  void deleteItem(
      AsyncSnapshot<List<Cart>> snapshot, int index, OrderProvider cart) {
    dbHelper!.delete(snapshot.data![index].id!);
    cart.removeCounter();
    cart.removeTotalPrice(
      double.parse(
        snapshot.data![index].productPrice.toString(),
      ),
    );
  }

  void sentToServer(
      AsyncSnapshot<List<Cart>> snapshot, OrderProvider cart) async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      setState(() => isLoading = true);
      name = _nameController.text.trim();
      List<Cart> orderData = await dbHelper!.getCartList() as List<Cart>;
      double totalPrice = cart.getTotalPrice();
      FirebaseFirestore.instance
          .collection('application')
          .doc("Data")
          .get()
          .then((snapshot) async {
        int totalOrders = snapshot['totalOrders'];
        await ApplicationDatabaseService().updateTotalOrder(totalOrders + 1);
        for (int i = 0; i < orderData.length; i++) {
          if (i == 0) {
            await OrderDatabaseService().addOrdersDetails(
              orderData[i].name!,
              orderData[i].quantity!,
              totalPrice,
              totalOrders + 1,
              name,
            );
          }
          await OrderDatabaseService().addOrder(
            orderData[i].name!,
            orderData[i].quantity!,
            totalPrice,
            totalOrders + 1,
            name,
          );
        }
      });
      popBack();
      dbHelper!.deleteWholeOrder();
      showConfirmation("\u2713 Order Placed!!");
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  void clearCart() {
    popBack();
    dbHelper!.deleteWholeOrder();
    showConfirmation("\u2713 Cart Clear!!");
  }

  void popBack() {
    Navigator.pop(context);
  }

  void showConfirmation(String msg) {
    final snackBar = SnackBar(
      backgroundColor: Colors.green,
      content: Text(msg),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String? nameValidator(String value) {
    if (value.isEmpty) {
      return 'Name is required...';
    } else if (value.length <= 1) {
      return 'Invalid Name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final cart = Provider.of<OrderProvider>(context);
    return Scaffold(
      body: FutureBuilder(
        future: cart.getData(),
        builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return EmptyCartWidget();
            } else {
              return Column(
                children: <Widget>[
                  const SizedBox(height: 30.0),
                  const NavBar(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8.0, bottom: 8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: SizedBox(
                                        height: size.height * 0.17,
                                        child: Image.network(
                                          snapshot.data![index].image
                                              .toString(),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              const SizedBox(height: 5.0),
                                              Text(
                                                snapshot.data![index].name
                                                    .toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 22.0,
                                                ),
                                              ),
                                              Text(
                                                snapshot
                                                    .data![index].description
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                width: size.width * 0.40,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0,
                                                        vertical: 4.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.blueAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    5.0,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: () =>
                                                          decrementItem(
                                                              snapshot,
                                                              index,
                                                              cart),
                                                      child: const Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                        size: 32.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data![index].quantity
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22.0,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () =>
                                                          incrementItem(
                                                              snapshot,
                                                              index,
                                                              cart),
                                                      child: const Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: 32.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          bottom: -20,
                                          right: -20,
                                          child: GestureDetector(
                                            onTap: () => deleteItem(
                                                snapshot, index, cart),
                                            child: const CircleAvatar(
                                              radius: 40.0,
                                              backgroundColor:
                                                  Colors.blueAccent,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 12,
                                          right: 12,
                                          child: GestureDetector(
                                            onTap: () => deleteItem(
                                                snapshot, index, cart),
                                            child: const Icon(
                                              Icons.delete_forever_rounded,
                                              color: Colors.white,
                                              size: 30.0,
                                            ),
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
                      },
                    ),
                  ),
                  Consumer<OrderProvider>(
                    builder: (context, value, child) {
                      return Visibility(
                        visible:
                            value.getTotalPrice().toStringAsFixed(2) == "0.00"
                                ? false
                                : true,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black38.withOpacity(0.2),
                                  offset: const Offset(0, -12),
                                  blurRadius: 16.0)
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ReusableWidget(
                                  title: 'Total',
                                  value:
                                      "\u20B9 ${value.getTotalPrice().toStringAsFixed(2)}",
                                ),
                              ),
                              Form(
                                key: _key,
                                autovalidateMode: _validate
                                    ? AutovalidateMode.always
                                    : AutovalidateMode.onUserInteraction,
                                child: InputField(
                                  hintText: "Enter Name",
                                  onSaved: (str) {
                                    name = str!;
                                  },
                                  controller: _nameController,
                                  onChanged: (str) {},
                                  keyboardType: TextInputType.name,
                                  validator: (value) => nameValidator(value!),
                                  titleFocusNode: _nameFocusNode,
                                  onEditingComplete: () {},
                                  icon: Icons.person,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    OrderAndClear(
                                      buttonText: "Clear",
                                      onPressed: () => clearCart(),
                                    ),
                                    OrderAndClear(
                                      buttonText: "Order",
                                      onPressed: () => !isLoading
                                          ? sentToServer(snapshot, cart)
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          }
          return const Text('');
        },
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle1,
          )
        ],
      ),
    );
  }
}

class OrderAndClear extends StatelessWidget {
  const OrderAndClear({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);
  final Function onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        width: size.width * 0.46,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 22.0,
            color: Colors.white,
          ),
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
            Icons.shopping_bag_rounded,
            size: 30.0,
          ),
          Center(
            child: Text(
              "Cart",
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
