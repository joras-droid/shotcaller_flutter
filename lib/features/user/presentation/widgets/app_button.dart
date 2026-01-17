// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const AppButton({Key? key, required this.title, required this.onPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF1D1D1D),
        border: BorderDirectional(top: BorderSide(color: Color(0xFFA16D47))),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      // For Shadow, Container used
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xffA16D47).withOpacity(0.4), // Shadow color
              blurRadius: 15,
              spreadRadius: 2,
              offset: Offset.zero,
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),

            backgroundColor: Color(0xffA16D47),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(16),
            ),

            overlayColor: Colors.white,
          ),

          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: .bold,
            ),
          ),
        ),
      ),
    );
  }
}
