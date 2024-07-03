import 'package:flutter/foundation.dart';

enum DashboardMode { SOH, LOCATION, REGISTRATION }

class DashboardScreenController extends ChangeNotifier {
  DashboardMode _dashboardMode = DashboardMode.SOH;
  DashboardMode get dashboardMode => _dashboardMode;

  void changeDashboardMode(DashboardMode dm) {
    _dashboardMode = dm;
    notifyListeners();
  }
}
