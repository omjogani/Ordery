import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationDatabaseService {
  final CollectionReference applicationCollection =
      FirebaseFirestore.instance.collection('application');

  Future insertDummyData() async {
    return await applicationCollection.doc("Data").set({
      'totalOrders': 0,
      'totalMenuItems':0,
    });
  }

  Future updateTotalOrder(int totalOrders) async {
    return await applicationCollection.doc("Data").update({
      'totalOrders': totalOrders,
    });
  }

  Future updateTotalMenuItem(int totalMenuItem) async {
    return await applicationCollection.doc("Data").update({
      'totalMenuItems': totalMenuItem,
    });
  }
}
