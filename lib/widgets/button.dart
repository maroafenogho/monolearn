import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(
      {Key? key,
      required this.buttonText,
      required this.onPressed,
      required this.color,
      required this.textColor,
      required this.borderColor,
      required this.borderRadius,
      required this.buttonHeight})
      : super(key: key);
  final String buttonText;
  final Function() onPressed;
  final Color color;
  final Color borderColor;
  final Color textColor;
  final double borderRadius;
  final double buttonHeight;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: textColor,
          ),
        ),
        style: TextButton.styleFrom(
          fixedSize: Size.fromHeight(buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
          side: BorderSide(
            width: 1.5,
            color: borderColor,
          ),
          backgroundColor: color,
          padding: const EdgeInsets.all(10),
        ));
  }
}
