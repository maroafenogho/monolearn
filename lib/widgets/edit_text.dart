import 'package:flutter/material.dart';
import 'package:mono_learn/utils/constants.dart';

class TFormField extends StatelessWidget {
  const TFormField({
    Key? key,
    required this.onChanged,
    required this.labelText,
    required this.obscure,
    required this.inputType,
    this.icon,
    this.suffixIcon,
    required this.onTap,
    required this.textCapitalization,
  }) : super(key: key);
  final Function(String text) onChanged;
  final String labelText;
  final bool obscure;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;
  final IconData? icon;
  final IconData? suffixIcon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: SizedBox(
        height: 40,
        child: TextFormField(
          cursorColor: kMainColor,
          textCapitalization: textCapitalization,
          keyboardType: inputType,
          obscureText: obscure,
          onChanged: onChanged,
          style: const TextStyle(
            color: kMainColor,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: kMainColor,
            ),
            suffixIcon: GestureDetector(
              child: Icon(
                suffixIcon,
                color: kMainColor,
              ),
              onTap: onTap,
            ),
            labelText: labelText,
            labelStyle: kEditTextHint,
            enabledBorder: kOutlineBorder,
            focusedBorder: kOutlineBorder,
          ),
        ),
      ),
    );
  }
}
