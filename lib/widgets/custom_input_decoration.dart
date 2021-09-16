import 'package:flutter/material.dart';

final customInputDecoration = ({BuildContext context, String hintText}) {
  InputDecoration(
    contentPadding: EdgeInsets.all(16),
    hintText: hintText,
    hintStyle: TextStyle(
      color: Theme.of(context).primaryColor,
    ),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );
};
