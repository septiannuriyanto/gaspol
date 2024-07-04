import 'package:flutter/foundation.dart';
import 'package:gaspol/controller/data/constants.dart';
import 'package:gaspol/controller/data/mongodb_controller.dart';
import 'package:gaspol/models/dashboard_model.dart';
import 'package:gaspol/models/gas_cylinder.dart';

enum DashboardMode { SOH, LOCATION, REGISTRATION }

class DashboardScreenController extends ChangeNotifier {
  DashboardMode _dashboardMode = DashboardMode.SOH;
  DashboardMode get dashboardMode => _dashboardMode;

  List<DashboardModel> _stockStatus = [];
  List<DashboardModel> get stockStatus => _stockStatus;

  List<GasCylinder> _unregisteredCylinder = [];
  List<GasCylinder> get unregisteredCylinder => _unregisteredCylinder;

  void changeDashboardMode(DashboardMode dm) {
    _dashboardMode = dm;
    notifyListeners();
  }

  void loadData() async {
    _stockStatus.clear();
    await Future.delayed(const Duration(seconds: 2));
    for (var element in Locations) {
      _stockStatus.add(DashboardModel.fromObjectMap(
          await MongoDatabase.getFilledGasCountAllTypeByLocation(element)));
    }

    notifyListeners();
  }

  loadUnregisteredCylinders() async {
    _unregisteredCylinder = await MongoDatabase.fetchUnregisteredCylinderList();
    notifyListeners();
  }

  approveRegistration(String gasId) async {
    await MongoDatabase.approvePendingRegistration(gasId);
    loadUnregisteredCylinders();
  }

  deleteRegistration(String gasId) async {
    await MongoDatabase.deletePendingRegistration(gasId);
    loadUnregisteredCylinders();
    notifyListeners();
  }
}
