import 'package:flutter/material.dart';

class IssuingScreenController extends ChangeNotifier {
  String _wrNumber = 'Input WR Number';
  String get wrNumber => _wrNumber;

  DateTime? _dateReceived;
  DateTime? get dateReceived => _dateReceived;

  String _location = 'Choose Location';
  String get location => _location;

  String _pic = 'Input PIC Name';
  String get pic => _pic;

  bool _isSet = false;
  bool get isSet => _isSet;

  int _stepper = 1;
  int get stepper => _stepper;

  void changeDate(DateTime date) {
    _dateReceived = date;
    notifyListeners();
  }

  void changeWRNumber(String wrNum) {
    _wrNumber = wrNum;
    notifyListeners();
  }

  void changeLocation(String loc) {
    _location = loc;
    notifyListeners();
  }

  void changePicName(String picName) {
    _pic = picName;
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

  void resetUIIssuingtates() {
    _wrNumber = 'Input WR Number';
    _dateReceived = null;
    _location = 'Choose Location';
    _pic = 'Input PIC Name';
    _isSet = false;
    _stepper = 1;

    notifyListeners();
  }

//------------------------------------------------------------------------------
}
