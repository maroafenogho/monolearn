import 'package:flutter/material.dart';

class ButtonLogin extends StatelessWidget {
  const ButtonLogin(
      {Key? key,
      required this.buttonChild,
      required this.onPressed,
      required this.color,
      required this.borderColor,
      required this.borderRadius,
      required this.buttonHeight})
      : super(key: key);
  final Widget buttonChild;
  final Function() onPressed;
  final Color color;
  final Color borderColor;
  final double borderRadius;
  final double buttonHeight;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: buttonChild,
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
        // padding: const EdgeInsets.all(10),
      ),
    );
  }
}
