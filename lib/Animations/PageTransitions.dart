import 'package:flutter/material.dart';

class FadePageTransition extends PageRouteBuilder {

  final Widget page;

  FadePageTransition({@required this.page}) :
    super(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child,);
      }
    );

}

class SlidePageTransition extends PageRouteBuilder {
  final Widget page;

  SlidePageTransition({@required this.page}) :
    super(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin = Offset(0.0, 1.0);
        Offset end = Offset.zero;
        Curve curve = Curves.easeInOut;
        Tween tween = Tween<Offset>(begin: begin, end: end);
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child
        );
      }
    );


}