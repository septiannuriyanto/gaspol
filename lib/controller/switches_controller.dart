import 'package:flutter/material.dart';

class SwitchesController extends ChangeNotifier {
  bool _tabungIsiSwitch = true;
  String _tabungIsiDesc = "Isi";

  bool get tabungIsiSwitch => _tabungIsiSwitch;
  String get tabungIsiDesc => _tabungIsiDesc;

  void toggleTabungIsi(bool value) {
    _tabungIsiSwitch = value;
    if (value == true) {
      _tabungIsiDesc = "Isi";
    } else {
      _tabungIsiDesc = "Kosong";
    }
    notifyListeners();
  }
}
