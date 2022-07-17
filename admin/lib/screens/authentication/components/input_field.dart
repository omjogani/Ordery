import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.hintText,
    required this.onSaved,
    required this.controller,
    required this.onChanged,
    required this.keyboardType,
    required this.validator,
    required this.titleFocusNode,
    required this.onEditingComplete,
    required this.icon,
  }) : super(key: key);
  final String hintText;
  final FormFieldSetter<String>? onSaved;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final FocusNode titleFocusNode;
  final Function onEditingComplete;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            width: size.width * 0.90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color.fromRGBO(72, 76, 82, 0.16),
                  offset: Offset(0, 12),
                  blurRadius: 16.0,
                )
              ],
            ),
            child: TextFormField(
              onChanged: onChanged,
              focusNode: titleFocusNode,
              onEditingComplete: () => onEditingComplete(),
              onSaved: onSaved,
              textInputAction: TextInputAction.next,
              validator: validator,
              controller: controller,
              keyboardType: keyboardType,
              cursorRadius: const Radius.circular(10.0),
              decoration: InputDecoration(
                hintText: hintText,
                icon: Icon(
                  icon,
                ),
                hintStyle: const TextStyle(
                  color: Colors.black54,
                ),
                errorStyle: const TextStyle(
                  color: Colors.redAccent,
                ),
                fillColor: Colors.black,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
