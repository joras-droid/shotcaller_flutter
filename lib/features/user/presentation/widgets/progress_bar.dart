// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progressValue;
  const ProgressBar({Key? key, required this.progressValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      tween: Tween<double>(begin: 0, end: progressValue),
      builder: (context, value, _) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[800],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          minHeight: 6,
        ),
      ),
    );
  }
}
