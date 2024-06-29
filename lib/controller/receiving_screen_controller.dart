import 'package:flutter/material.dart';
import 'package:gaspol/view/utils/datetime_formatter.dart';

class ReceivingScreenController extends ChangeNotifier {
  String _poNumber = 'Input PO Number';
  DateTime? _dateReceived;
  bool _isSet = false;
  int _stepper = 0;

  final dateController = TextEditingController();

  String get poNumber => _poNumber;
  DateTime? get dateReceived => _dateReceived;
  bool get isSet => _isSet;
  int get stepper => _stepper;

  void changeDate(DateTime date) {
    _dateReceived = date;
    _dateReceived = date;
    notifyListeners();
  }

  void changePONumber(String poNumber) {
    _poNumber = poNumber;
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
