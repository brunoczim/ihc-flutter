import 'package:flutter/material.dart';

class PresButton extends StatelessWidget {
  final String text;

  final double margin;

  final double padding;

  final void Function()? onPressed;

  final TextStyle? textStyle;

  final ButtonStyle? buttonStyle;

  PresButton({
    super.key,
    required this.text,
    this.margin = 8.0,
    this.padding = 8.0,
    this.onPressed = null,
    this.textStyle = null,
    this.buttonStyle = null,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: margin),
      child: OutlinedButton(
        style: buttonStyle,
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Text(
            text,
            style: textStyle,
          ),
        )
      )
    );
  }
}

