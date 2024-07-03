import 'package:flutter/material.dart';
import 'package:gaspol/controller/data/mongodb_controller.dart';
import 'package:gaspol/models/gas_cylinder.dart';
import 'package:gaspol/models/transaction_model.dart';

enum KeywordFoundStatus {
  FOUND_ON_BOTH,
  FOUND_ON_RECEIVED,
  FOUND_ON_STOCK,
  NOT_FOUND_ON_BOTH
}

enum AutoCompleteType {
  ADD_ITEM,
  DISPLAY_LIST,
  DISPLAY_NULL_LIST,
  WAITING,
  DISPLAY_PARTIAL_LIST
}

enum ProcessType { RECEIVING, RETURNING, CHECKOUT }

enum SearchResult { EXACT, PARTIAL, NOTFOUND }

class DataController extends ChangeNotifier {
  List<GasCylinder> _cylinderList = [];

  List<GasCylinder> get cylinderList => _cylinderList;

  List<GasCylinder> _filteredCylinderList = [];
  List<GasCylinder> get filteredCylinderList => _filteredCylinderList;

  List<GasCylinder> _cylinderToReceive = [];
  List<GasCylinder> get cylinderToReceive => _cylinderToReceive;

  List<GasCylinder> _cylinderToReturn = [];
  List<GasCylinder> get cylinderToReturn => _cylinderToReturn;

  int _filteredcylinderLength = 0;
  int get filteredcylinderLength => _filteredcylinderLength;

  KeywordFoundStatus _keywordFoundStatus = KeywordFoundStatus.NOT_FOUND_ON_BOTH;
  KeywordFoundStatus get keywordFoundStatus => _keywordFoundStatus;

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  String _poNumber = '';
  String get poNumber => _poNumber;

  AutoCompleteType _autoCompleteType = AutoCompleteType.WAITING;
  AutoCompleteType get autoCompleteType => _autoCompleteType;

  SearchResult _searchResult = SearchResult.NOTFOUND;
  SearchResult get searchResult => _searchResult;

  ProcessType _processType = ProcessType.RECEIVING;
  ProcessType get processType => _processType;

  addToCylinderRegister(GasCylinder cyl) async {
    _cylinderList.add(cyl);
    await MongoDatabase.registerCylinder(cyl);

    notifyListeners();
  }

  proceedToReturn() {
    _processType = ProcessType.RETURNING;
    notifyListeners();
  }

  proceedToCheckout() {
    _processType = ProcessType.CHECKOUT;
    notifyListeners();
  }

  searchCylinder() async {
    print(processType);
    //sort raw data if using sample from offline list
    // _cylinderList.sort((a, b) => a.gasId.compareTo(b.gasId));

    //if any string inserted, then create and fill filteredcylinderlist with some filter from raw data
    _cylinderList.clear();
    // _cylinderList = await MongoDatabase.fetchAllCylinderList();
    if (_processType == ProcessType.RECEIVING) {
      _cylinderList = await MongoDatabase.fetchAllCylinderList();
    } else {
      _cylinderList = await MongoDatabase.fetchEmptyCylinderList();
    }

    if (_cylinderNumber.isNotEmpty) {
      bool isPartial = false;
      bool isFull = false;

      List<GasCylinder> _testPartialCylinders = _cylinderList
          .where((listItem) => listItem.gasId.contains(_cylinderNumber))
          .toList();
      _filteredCylinderList.clear();
      _filteredCylinderList = _testPartialCylinders;

      isPartial = _testPartialCylinders.length > 0;
      List<GasCylinder> _testFullCylinders = _cylinderList
          .where((listItem) => listItem.gasId == _cylinderNumber)
          .toList();
      isFull = _testFullCylinders.length > 0;

      if (isFull) {
        _searchResult = SearchResult.EXACT;
      } else {
        if (isPartial) {
          _searchResult = SearchResult.PARTIAL;
        } else {
          _searchResult = SearchResult.NOTFOUND;
        }
      }

      //remove any filtered item when there is same item in received list

      _filteredcylinderLength = _filteredCylinderList.length;
    }

    checkIsAvailable(_cylinderNumber);
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

  Future<String> addCylinderToReceive(GasCylinder cyl) async {
    for (var element in _cylinderToReceive) {
      if (element.gasId == cyl.gasId) {
        return "Item ini sudah anda pilih";
      }
    }

    _cylinderToReceive.add(cyl);
    _filteredCylinderList.removeWhere((e) => e.gasId == cyl.gasId);

    notifyListeners();
    return 'success';
  }

  Future<String> addCylinderToReturn(GasCylinder cyl) async {
    for (var element in _cylinderToReturn) {
      if (element.gasId == cyl.gasId) {
        return "Item ini sudah anda pilih";
      }
    }

    _cylinderToReturn.add(cyl);
    _filteredCylinderList.removeWhere((e) => e.gasId == cyl.gasId);

    notifyListeners();
    return 'success';
  }

  void removeCylinderFromReceivingList(String id) {
    GasCylinder _cyl = _cylinderToReceive.where((e) => e.gasId == id).first;
    _filteredCylinderList.add(_cyl);
    _filteredCylinderList.sort((a, b) => a.gasId.compareTo(b.gasId));
    _cylinderToReceive.removeWhere((item) => item.gasId == id);
    checkIsAvailable(id);
    notifyListeners();
  }

  void removeCylinderFromReturnList(String id) {
    GasCylinder _cyl = _cylinderToReturn.where((e) => e.gasId == id).first;
    _filteredCylinderList.add(_cyl);
    _filteredCylinderList.sort((a, b) => a.gasId.compareTo(b.gasId));
    _cylinderToReturn.removeWhere((item) => item.gasId == id);
    checkIsAvailable(id);
    notifyListeners();
  }

  void checkIsAvailable(String keyword) {
    bool isOnWaitingList = false;

    if (_processType == ProcessType.RECEIVING) {
      isOnWaitingList =
          _cylinderToReceive.where((e) => e.gasId == keyword).length > 0;
    } else {
      isOnWaitingList =
          _cylinderToReturn.where((e) => e.gasId == keyword).length > 0;
    }

    bool isOnFilteredList = filteredcylinderLength > 0;

    //logic check
    if (!isOnFilteredList && isOnWaitingList) {
      _autoCompleteType = AutoCompleteType.DISPLAY_NULL_LIST;
    } else if (!isOnFilteredList && !isOnWaitingList) {
      _autoCompleteType = AutoCompleteType.ADD_ITEM;
    } else if (isOnFilteredList && !isOnWaitingList) {
      _autoCompleteType = AutoCompleteType.DISPLAY_LIST;
    } else {
      _autoCompleteType = AutoCompleteType.DISPLAY_NULL_LIST;
    }
    notifyListeners();
  }

  void changeAutoCompleteState(AutoCompleteType autocomplete) {
    _autoCompleteType = autocomplete;
    notifyListeners();
  }

  checkoutReceiving(String poNumber, DateTime dt) async {
    GasTransaction txTransaction = GasTransaction(
      transDate: dt,
      from: 'SM',
      to: 'SUPPLIER',
      transactionCategory: TransactionCategory.OUTGOING,
      delegator: 'WAREHOUSE CREW',
      receiver: 'DRIVER SUPPLIER',
      documentNumber: poNumber,
      gasCylinder: _cylinderToReturn,
    );

    GasTransaction rxTransaction = GasTransaction(
      transDate: dt,
      from: 'SUPPLIER',
      to: 'SM',
      transactionCategory: TransactionCategory.INCOMING,
      delegator: 'DRIVER SUPPLIER',
      receiver: 'WAREHOUSE CREW',
      documentNumber: poNumber,
      gasCylinder: cylinderToReceive,
    );

    await MongoDatabase.transactionProcess(txTransaction);
    await MongoDatabase.transactionProcess(rxTransaction);
  }

  resetAllReceivingStates() {}
}
