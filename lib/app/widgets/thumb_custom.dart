import 'package:flutter/material.dart';

class ThumbCustom extends StatelessWidget {
  const ThumbCustom({
    Key? key,
    required this.size,
    required this.color,
    this.borderWidth = 4.0,
    this.borderColor = Colors.white,
  }) : super(key: key);

  final double size;

  final Color color;

  final double borderWidth;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(16, 0, 0, 0),
            blurRadius: 4,
            spreadRadius: 4,
          )
        ],
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      alignment: Alignment.center,
    );
  }
}
