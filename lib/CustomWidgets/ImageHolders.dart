import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {

  CircularImage({required this.image, required this.diameter});

  final double diameter;
  final Image image;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.cover,
              image: image.image
          ),
        )
    );
  }

}