import 'package:flutter/material.dart';
import 'package:gaspol/models/gas_cylinder.dart';

enum KeywordFoundStatus {
  FOUND_ON_BOTH,
  FOUND_ON_RECEIVED,
  FOUND_ON_STOCK,
  NOT_FOUND_ON_BOTH
}

enum SearchCommand {
  ADD_ITEM,
  DISPLAY_LIST,
  DISPLAY_NULL_LIST,
}

class DataController extends ChangeNotifier {
  List<GasCylinder> _cylinderList = [
    GasCylinder(
        gasId: '831479',
        gasName: 'Acetylene',
        gasType: GasType.ACETYLENE,
        dateRegistered: DateTime.now(),
        location: "SUPPLIER",
        registerStatus: RegisterStatus.REGISTERED),
    GasCylinder(
        gasId: '592384',
        gasName: 'Oxygen',
        gasType: GasType.OXYGENT,
        dateRegistered: DateTime.now(),
        location: "SUPPLIER",
        registerStatus: RegisterStatus.REGISTERED),
    GasCylinder(
        gasId: '746281',
        gasName: 'Nitrogen',
        gasType: GasType.NITROGEN,
        dateRegistered: DateTime.now(),
        location: "SUPPLIER",
        registerStatus: RegisterStatus.REGISTERED),
    GasCylinder(
        gasId: '358192',
        gasName: 'Carbon',
        gasType: GasType.CARBON,
        dateRegistered: DateTime.now(),
        location: "SUPPLIER",
        registerStatus: RegisterStatus.REGISTERED),
    GasCylinder(
        gasId: '905612',
        gasName: 'Acetylene',
        gasType: GasType.ACETYLENE,
        dateRegistered: DateTime.now(),
        location: "SUPPLIER",
        registerStatus: RegisterStatus.REGISTERED),
    GasCylinder(
        gasId: '263417',
        gasName: 'Oxygen',
        gasType: GasType.OXYGENT,
        dateRegistered: DateTime.now(),
        location: "SUPPLIER",
        registerStatus: RegisterStatus.REGISTERED),
    GasCylinder(
        gasId: '374582',
        gasName: 'Nitrogen',
        gasType: GasType.NITROGEN,
        dateRegistered: DateTime.now(),
        location: "SUPPLIER",
        registerStatus: RegisterStatus.REGISTERED),
    GasCylinder(
        gasId: '481306',
        gasName: 'Carbon',
        gasType: GasType.CARBON,
        dateRegistered: DateTime.now(),
        location: "SUPPLIER",
        registerStatus: RegisterStatus.REGISTERED),
    GasCylinder(
        gasId: '192837',
        gasName: 'Acetylene',
        gasType: GasType.ACETYLENE,
        dateRegistered: DateTime.now(),
        location: "SUPPLIER",
        registerStatus: RegisterStatus.REGISTERED),
    GasCylinder(
        gasId: '284756',
        gasName: 'Oxygen',
        gasType: GasType.OXYGENT,
        dateRegistered: DateTime.now(),
        location: "SUPPLIER",
        registerStatus: RegisterStatus.REGISTERED),
    GasCylinder(
        gasId: '375648',
        gasName: 'Nitrogen',
        gasType: GasType.NITROGEN,
        dateRegistered: DateTime.now(),
        location: "SUPPLIER",
        registerStatus: RegisterStatus.REGISTERED),
    GasCylinder(
        gasId: '493827',
        gasName: 'Carbon',
        gasType: GasType.CARBON,
        dateRegistered: DateTime.now(),
        location: "SUPPLIER",
        registerStatus: RegisterStatus.REGISTERED),
    GasCylinder(
        gasId: '564738',
        gasName: 'Acetylene',
        gasType: GasType.ACETYLENE,
        dateRegistered: DateTime.now(),
        location: "SUPPLIER",
        registerStatus: RegisterStatus.REGISTERED),
    GasCylinder(
        gasId: '687495',
        gasName: 'Oxygen',
        gasType: GasType.OXYGENT,
        dateRegistered: DateTime.now(),
        location: "SUPPLIER",
        registerStatus: RegisterStatus.REGISTERED),
  ];

  List<GasCylinder> _filteredCylinderList = [];
  List<GasCylinder> _cylinderToReceive = [];

  int _filteredcylinderLength = 0;
  KeywordFoundStatus _keywordFoundStatus = KeywordFoundStatus.NOT_FOUND_ON_BOTH;
  SearchCommand _searchCommand = SearchCommand.DISPLAY_NULL_LIST;
  bool _isAvailable = false;

  List<GasCylinder> get cylinderList => _cylinderList;
  List<GasCylinder> get filteredCylinderList => _filteredCylinderList;
  List<GasCylinder> get cylinderToReceive => _cylinderToReceive;
  bool get isAvailable => _isAvailable;
  int get filteredcylinderLength => _filteredcylinderLength;

  KeywordFoundStatus get keywordFoundStatus => _keywordFoundStatus;
  SearchCommand get searchCommand => _searchCommand;

  addToCylinderRegister(GasCylinder cyl) async {
    _cylinderList.add(cyl);

    notifyListeners();
  }

  resetSearchText() {
    _searchCommand = SearchCommand.DISPLAY_LIST;
    notifyListeners();
  }

  void searchCylinder(String keyword) {
    //sort raw data
    _cylinderList.sort((a, b) => a.gasId.compareTo(b.gasId));

    //if any string inserted, then create and fill filteredcylinderlist with some filter from raw data
    if (keyword.isNotEmpty) {
      _filteredCylinderList = _cylinderList
          .where((listItem) => listItem.gasId.contains(keyword))
          .toList();

      //remove any filtered item when there is same item in received list
      for (var cyl in _cylinderToReceive) {
        _filteredCylinderList.remove(cyl);
      }
      _filteredcylinderLength = _filteredCylinderList.length;
    }

    checkIsAvailable(keyword);
    notifyListeners();
  }

  String _cylinderNumber = '';
  String get cylinderNumber => _cylinderNumber;

  void setCylinderNumber(String newCylNumber) {
    _cylinderNumber = newCylNumber;
    notifyListeners();
  }

  void resetCylinderNumber() {
    _cylinderNumber = '';
    notifyListeners();
  }

  void addCylinder(GasCylinder cyl) {
    _cylinderToReceive.add(cyl);
    _filteredCylinderList.removeWhere((e) => e.gasId == cyl.gasId);
    notifyListeners();
  }

  void removeCylinder(String id) {
    GasCylinder _cyl = _cylinderToReceive.where((e) => e.gasId == id).first;
    _filteredCylinderList.add(_cyl);
    _filteredCylinderList.sort((a, b) => a.gasId.compareTo(b.gasId));
    _cylinderToReceive.removeWhere((item) => item.gasId == id);
    checkIsAvailable(id);
    notifyListeners();
  }

  void checkIsAvailable(String keyword) {
    bool isOnReceivedList =
        _cylinderToReceive.where((e) => e.gasId == keyword).length > 0;
    bool isOnFilteredList = _isAvailable = filteredcylinderLength > 0;

    //logic check
    if (!isOnFilteredList && isOnReceivedList) {
      _searchCommand = SearchCommand.DISPLAY_NULL_LIST;
    } else if (!isOnFilteredList && !isOnReceivedList) {
      _searchCommand = SearchCommand.ADD_ITEM;
    } else if (isOnFilteredList && !isOnReceivedList) {
      _searchCommand = SearchCommand.DISPLAY_LIST;
    } else {
      _searchCommand = SearchCommand.DISPLAY_NULL_LIST;
    }
    notifyListeners();
  }
}
