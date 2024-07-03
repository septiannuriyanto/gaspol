import 'package:flutter/material.dart';

class IssuingScreenController extends ChangeNotifier {
  String _wrNumber = 'Input WR Number';
  String get wrNumber => _wrNumber;

  DateTime? _dateReceived;
  DateTime? get dateReceived => _dateReceived;

  bool _isSet = false;
  bool get isSet => _isSet;

  int _stepper = 0;
  int get stepper => _stepper;

  final dateController = TextEditingController();

  void changeDate(DateTime date) {
    _dateReceived = date;
    notifyListeners();
  }

  void changePONumber(String poNumber) {
    _wrNumber = poNumber;
    notifyListeners();
  }

  void lockHeaderData() {
    _isSet = true;
    addStepper();
    notifyListeners();
  }

  void addStepper() {
    _stepper++;
    notifyListeners();
  }

//------------------------------------------------------------------------------
}
