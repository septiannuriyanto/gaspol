import 'package:flutter/material.dart';
import 'package:gaspol/controller/data/data_controller.dart';
import 'package:gaspol/models/gas_cylinder.dart';
import 'package:gaspol/view/utils/datetime_formatter.dart';

class ReceivingScreenController extends ChangeNotifier {
  String _poNumber = 'Input PO Number';
  String get poNumber => _poNumber;

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
