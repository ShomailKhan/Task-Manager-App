import 'package:flutter/material.dart';

class Textfields extends StatelessWidget {
  const Textfields({super.key, required this.hintText, required this.controllerType});
  final String hintText;
  final TextEditingController controllerType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controllerType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        fillColor: Color.fromRGBO(245, 247, 249, 1),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color.fromRGBO(245, 247, 249, 1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color.fromRGBO(245, 247, 249, 1)),
        ),
      ),
    );
  }
}
