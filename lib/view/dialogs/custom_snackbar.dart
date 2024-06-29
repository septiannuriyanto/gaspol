import 'package:flutter/material.dart';

void cSnackbar(BuildContext context, String Message, int second) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(Message),
    duration: Duration(seconds: second),
  ));
}
