import 'package:flutter/material.dart';

enum LightSourcePosition { topRight, bottomRight, bottomLeft, topLeft }

class LightSource extends StatelessWidget {
  final double angle;
  final LightSourcePosition position;
  final bool isEnabled;
  final Function() onTap;
  LightSource({required this.angle,required this.position,required this.isEnabled,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50, //size.width > 400 ? 80 : 50,
        width: 50, //size.width > 400 ? 80 : 50,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset(5, 3),
                  blurRadius: 5,
                  // spreadRadius: 10,
                  color: Colors.grey)
            ]),
        child: Transform.rotate(
          angle: angle,
          child: Icon(
            Icons.highlight,
            color: isEnabled ? Colors.yellow : Colors.grey,
            size: 50,
          ),
        ),
      ),
    );
  }
}
