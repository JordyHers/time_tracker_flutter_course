import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton(
      {this.child,
      this.onPressed,
      this.borderRadius: 4.0,
      this.color,
      this.height: 50.0});

  final Widget child;
  final Color color;

  final double height;
  final double borderRadius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: child,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
