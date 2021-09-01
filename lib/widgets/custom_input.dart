import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final bool obscureText;

  const CustomInput({@required this.hintText, this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16),
          hintText: this.hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          )),
      obscureText: this.obscureText ?? false,
    );
  }
}
