// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class OrderScreen extends StatefulWidget {
//   const OrderScreen({Key? key}) : super(key: key);

//   @override
//   State<OrderScreen> createState() => _OrderScreenState();
// }

// class _OrderScreenState extends State<OrderScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('orders')
//             .doc()
//             .snapshots(),
//         builder:
//             (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//           if (snapshot.data == null) {
//             return Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   CupertinoActivityIndicator(),
//                   const Text(
//                     "Fetching Data...",
//                     maxLines: 2,
//                     style: TextStyle(
//                       fontSize: 20.0,
//                       color: Colors.black,
//                     ),
//                   )
//                 ],
//               ),
//             );
//           }

//           final DocumentSnapshot document = snapshot.data as DocumentSnapshot;

//           final Map<String, dynamic> documentData =
//               document.data() as Map<String, dynamic>;

//           List checkingForEmptyList = documentData['order'];
//           if (documentData['order'] == null || checkingForEmptyList.isEmpty) {
//             return Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Lottie.asset(
//                     "assets/lottie/no_items_found.json",
//                     height: 200.0,
//                     width: 200.0,
//                   ),
//                   Text(
//                     widget.isPasswordSection
//                         ? "Empty Password Section..."
//                         : "Empty Notebook...",
//                     maxLines: 2,
//                     style: const TextStyle(
//                       fontSize: 20.0,
//                       color: Colors.black,
//                     ),
//                   )
//                 ],
//               ),
//             );
//           }

//           final List<Map<String, dynamic>> itemDetailList =
//               (documentData['order'] as List)
//                   .map((itemDetail) => itemDetail as Map<String, dynamic>)
//                   .toList();
//           var itemDetailsListReversed = itemDetailList.reversed.toList();

//           _buildListTileHere(int index) {
//             final Map<String, dynamic> itemDetail =
//                 itemDetailsListReversed[index];
//             final String title = itemDetail['title'];
//             final DateTime dateTime = itemDetail['dateTime'].toDate();
//             return Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(10.0),
//                 child: Dismissible(
//                   key: Key(
//                       (itemDetailsListReversed.length - index - 1).toString()),
//                   confirmDismiss: (direction) async {
//                     return await DismissConfirmation(
//                         context, itemDetailsListReversed, index);
//                   },
//                   background: TileBackground(true),
//                   secondaryBackground: TileBackground(false),
//                   child: ListTile(
//                     title: title,
//                     // title: "${reversedNotes[index]['title']}",
//                     // dateTime: reversedNotes[index]['dateTime'].toDate(),
//                     dateTime: dateTime,
//                     onPressed: () {
//                       // view details
//                     },
//                   ),
//                 ),
//               ),
//             );
//           }

//           return Expanded(
//             child: ListView.builder(
//               itemCount: itemDetailsListReversed.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return _buildListTileHere(index);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
