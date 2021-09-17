import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextInputAction textInputAction;
  final Function onFieldSubmitted;
  final Function validator;
  final FocusNode focusNode;
  final TextEditingController controller;
  final Function onSaved;
  final TextInputType keyboardType;

  const CustomInput({
    @required this.hintText,
    this.textInputAction,
    this.onFieldSubmitted,
    this.validator,
    this.focusNode,
    this.obscureText = false,
    this.controller,
    this.onSaved,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
        ),
      ),
      obscureText: this.obscureText ?? false,
      textInputAction: this.textInputAction,
      onFieldSubmitted: this.onFieldSubmitted,
      validator: this.validator,
      focusNode: this.focusNode,
      controller: this.controller,
      onSaved: this.onSaved,
      keyboardType: this.keyboardType,
    );
  }
}
