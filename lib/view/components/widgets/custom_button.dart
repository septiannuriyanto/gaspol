import 'package:flutter/material.dart';

class CButton extends StatelessWidget {
  CButton({
    this.buttonColor,
    required this.onPressed,
    this.caption,
    super.key,
  });
  final String? caption;
  final void Function()? onPressed;
  final Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(caption ?? "Submit"),
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(buttonColor ?? Colors.grey)),
    );
  }
}
