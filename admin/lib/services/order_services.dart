import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDatabaseService {
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('orders');

  Future insertDummyData() async {
    return await orderCollection.doc("0").set({
      'date': DateTime.now(),
      "orderId": 1,
      "isPending": true,
      "totalPrice": 0,
      'orders': FieldValue.arrayUnion([
        {
          "itemName": "Burger",
          "quantity": 2,
        }
      ]),
    });
  }

  Future addOrder(
      String itemName, int quantity, double totalPrice, int totalOrders, String name) async {

    List newListToBeStored = [];
    newListToBeStored.add({
      "itemName": itemName,
      "quantity": quantity,
    });

    return await orderCollection.doc("$totalOrders").update({
      'order': FieldValue.arrayUnion(newListToBeStored),
      'orderId': totalOrders,
      'isPending': true,
      'totalPrice': totalPrice,
      'date': DateTime.now(),
      'name' : name,
    });
  }

  Future addOrdersDetails(
      String itemName, int quantity,double totalPrice, int totalOrders, String name) async {
    List newListToBeStored = [];
    newListToBeStored.add({
      "itemName": itemName,
      "quantity": quantity,
    });
    return await orderCollection.doc("$totalOrders").set({
      'order': FieldValue.arrayUnion(newListToBeStored),
      'orderId': totalOrders,
      'isPending': true,
      'totalPrice': totalPrice,
      'date': DateTime.now(),
      'name' : name,
    });
  }
}
