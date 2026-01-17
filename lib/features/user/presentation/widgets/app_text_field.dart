// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;

  const AppTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),

      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.white,
          // fontSize: 24,
          fontWeight: .bold,
        ),

        floatingLabelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),

        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFFD4A574).withOpacity(0.5),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD4A574)),
        ),
      ),
      keyboardType: textInputType,
      validator: validator,
    );
  }
}
