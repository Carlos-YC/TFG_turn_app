import 'package:flutter/material.dart';

class CustomBoxDecoration extends StatelessWidget {
  final Color color1;
  final Color color2;

  CustomBoxDecoration({this.color1, this.color2});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
    );
  }
}
