import 'package:flutter/material.dart';

/// Custom page route with black background transition
class BlackPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  BlackPageRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Fade transition with black background
            return Container(
              color: Colors.black,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );

  @override
  Color? get barrierColor => Colors.black;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => true;
}

/// Helper function to create a black page route
PageRoute<T> createBlackPageRoute<T>(Widget page) {
  return BlackPageRoute<T>(child: page);
}

