import 'package:admin/screens/authentication/components/description_field.dart';
import 'package:admin/screens/authentication/components/input_field.dart';
import 'package:admin/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMenuItem extends StatefulWidget {
  const AddMenuItem({
    Key? key,
    required this.auth,
  }) : super(key: key);
  final AuthBase auth;

  @override
  State<AddMenuItem> createState() => _AddMenuItemState();
}

class _AddMenuItemState extends State<AddMenuItem> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  late String name, description, price;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  String errorMessage = "";
  bool _validate = false;
  bool isLoading = false;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;

  Future getImage() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final XFile xImageTemp = XFile(pickedFile.path);

        FirebaseFirestore.instance
            .collection("application")
            .doc("Data")
            .get()
            .then((snapshot) async {
          int totalMenuItems = snapshot['totalMenuItems'];
          _storage
              .ref("menus/$name.jpg")
              .putData(await xImageTemp.readAsBytes())
              .then((snapshot) {
            snapshot.ref.getDownloadURL().then((url) {
              List listToBeSet = [];
              listToBeSet.add({
                "name": name,
                "description": description,
                "price": price,
                "photoURL": url,
              });
              _firestore.collection("menu").doc("Data").update({
                'menu': FieldValue.arrayUnion(listToBeSet),
              });
              _firestore
                  .collection("application")
                  .doc("Data")
                  .get()
                  .then((snapshot) {
                _firestore.collection("application").doc("Data").update({
                  "totalMenuItems": snapshot['totalMenuItems'] + 1,
                });
              });
              final snackBar = SnackBar(content: Text("Added Successfully!"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          });
        });
      } else {
        const snackBar = SnackBar(
          content: Text("You haven't selected any Image!"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30.0),
            const NavBar(),
            Form(
              key: _key,
              autovalidateMode: _validate
                  ? AutovalidateMode.always
                  : AutovalidateMode.onUserInteraction,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 40.0),
                  InputField(
                    controller: _nameController,
                    hintText: "Enter Item Name",
                    icon: Icons.book,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) {},
                    onEditingComplete: () {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    onSaved: (str) {
                      name = str!;
                    },
                    validator: (str) => validateName(str!),
                    titleFocusNode: _nameFocusNode,
                  ),
                  CustomTextAreaField(
                    controller: _descriptionController,
                    hintText: "Enter Item Description",
                    keyboardType: TextInputType.text,
                    onChanged: (val) {},
                    onSaved: (str) {
                      description = str!;
                    },
                    validator: (str) => validateDescription(str!),
                    descriptionFocusNode: _descriptionFocusNode,
                  ),
                  InputField(
                    controller: _priceController,
                    hintText: "Enter Price",
                    icon: Icons.money,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {},
                    onEditingComplete: () {},
                    onSaved: (str) {
                      price = str!;
                    },
                    validator: (str) => validatePrice(str!),
                    titleFocusNode: _priceFocusNode,
                  ),
                  const Text(
                    "Click Submit to choose Image and Submit.",
                  ),
                  const SizedBox(height: 5.0),
                  AddButton(
                    buttonText: "SUBMIT",
                    onPressed: () => getImage(),
                  ),
                  const SizedBox(height: 30.0),
                  AddButton(
                    buttonText: "Logout",
                    onPressed: () {
                      try {
                        widget.auth.signOut();
                      } catch (e) {
                        final snackBar = SnackBar(content: Text("ERROR: $e!"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String? validateName(String value) {
    if (value.isEmpty) {
      return "Name is Required...";
    } else if (value.length <= 1) {
      return 'Invalid Name!';
    }
    return null;
  }

  String? validateDescription(String value) {
    if (value.isEmpty) {
      return "Description is Required...";
    } else if (value.length <= 1) {
      return 'Invalid Description...';
    }
    return null;
  }

  String? validatePrice(String value) {
    if (value.isEmpty) {
      return "Price is Required...";
    } else if (int.parse(value) <= 1) {
      return 'Price must be greater than 1!';
    }
    return null;
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
        ],
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);
  final String buttonText;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        width: size.width * 0.90,
        height: 55.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
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
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 22.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
