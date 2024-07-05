import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaspol/controller/app_config.dart';
import 'package:gaspol/controller/home_screen_controller.dart';
import 'package:gaspol/controller/switches_controller.dart';
import 'package:gaspol/models/gas_cylinder.dart';
import 'package:gaspol/view/components/themes/colors.dart';
import 'package:gaspol/view/components/themes/layouts.dart';
import 'package:gaspol/view/components/widgets/custom_button.dart';
import 'package:gaspol/view/components/widgets/custom_textfield.dart';
import 'package:gaspol/view/dialogs/custom_snackbar.dart';
import 'package:gaspol/view/utils/datetime_formatter.dart';
import 'package:provider/provider.dart';

import '../../components/atomic/widget_props.dart';
import '../../components/themes/constants.dart';

enum Options { approve, delete }

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardScreenController _dbController =
        Provider.of<DashboardScreenController>(context);
    return Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome, User",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            "Hari ini : ${todayInd}",
            style: TextStyle(color: MainColor.getColor(1), fontSize: 12),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    _dbController.changeDashboardMode(DashboardMode.SOH);
                  },
                  icon: Icon(
                    Icons.list,
                    color: _dbController.dashboardMode == DashboardMode.SOH
                        ? Colors.white
                        : Colors.white38,
                  )),
              IconButton(
                  onPressed: () {
                    _dbController.changeDashboardMode(DashboardMode.LOCATION);
                  },
                  icon: Icon(
                    Icons.location_on_outlined,
                    color: _dbController.dashboardMode == DashboardMode.LOCATION
                        ? Colors.white
                        : Colors.white38,
                  )),
              IconButton(
                  onPressed: () async {
                    _dbController
                        .changeDashboardMode(DashboardMode.REGISTRATION);
                    await _dbController.loadUnregisteredCylinders();
                  },
                  icon: Icon(
                    Icons.queue,
                    color: _dbController.dashboardMode ==
                            DashboardMode.REGISTRATION
                        ? Colors.white
                        : Colors.white38,
                  )),
            ],
          ),
          Expanded(
            child: _dbController.dashboardMode == DashboardMode.SOH
                ? _buildStockDashboard(context)
                : _dbController.dashboardMode == DashboardMode.LOCATION
                    ? _buildLocationDashboard(context)
                    : _buildRegistrationDashboard(context),
          )
        ],
      ),
    );
  }

  _buildStockDashboard(BuildContext context) {
    DashboardScreenController _dbController =
        Provider.of<DashboardScreenController>(context);

    return Container(
      constraints: BoxConstraints(
        minHeight: getW(context),
        minWidth: getW(context),
      ),
      decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: kDefaultBorderRadiusAll,
          boxShadow: [kDefaultBoxShadow]),
      child: Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(kDefaultPadding),
              child: Text(
                "Stock Ready",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MainColor.getColor(6)),
              ),
            ),
            Container(
              margin: kDefaultEdgeInsets,
              decoration: BoxDecoration(
                  border: Border.all(color: MainColor.getColor(0)),
                  borderRadius: kDefaultBorderRadiusAll),
              child: ListTile(
                leading: Image.asset(
                  "lib/assets/image/acetylene.png",
                  width: 36,
                  height: 36,
                ),
                title: Text("Acetylene"),
                subtitle: Text("Isi"),
                trailing: _dbController.stockStatus.isEmpty
                    ? SizedBox(
                        height: 36,
                        width: 36,
                        child: CircularProgressIndicator(
                          color: MainColor.getColor(2),
                        ))
                    : Text(
                        _dbController.stockStatus[1].filledQty[0].toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            Container(
              margin: kDefaultEdgeInsets,
              decoration: BoxDecoration(
                  border: Border.all(color: MainColor.getColor(0)),
                  borderRadius: kDefaultBorderRadiusAll),
              child: ListTile(
                leading: Image.asset(
                  "lib/assets/image/nitrogen.png",
                  width: 36,
                  height: 36,
                ),
                title: Text("Nitrogen"),
                subtitle: Text("Isi"),
                trailing: _dbController.stockStatus.isEmpty
                    ? SizedBox(
                        height: 36,
                        width: 36,
                        child: CircularProgressIndicator(
                          color: MainColor.getColor(2),
                        ))
                    : Text(
                        _dbController.stockStatus[1].filledQty[1].toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            Container(
              margin: kDefaultEdgeInsets,
              decoration: BoxDecoration(
                  border: Border.all(color: MainColor.getColor(0)),
                  borderRadius: kDefaultBorderRadiusAll),
              child: ListTile(
                leading: Image.asset(
                  "lib/assets/image/oxygent.png",
                  width: 36,
                  height: 36,
                ),
                title: Text("Oxygen"),
                subtitle: Text("Isi"),
                trailing: _dbController.stockStatus.isEmpty
                    ? SizedBox(
                        height: 36,
                        width: 36,
                        child: CircularProgressIndicator(
                          color: MainColor.getColor(2),
                        ))
                    : Text(
                        _dbController.stockStatus[1].filledQty[2].toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            Container(
              margin: kDefaultEdgeInsets,
              decoration: BoxDecoration(
                  border: Border.all(color: MainColor.getColor(0)),
                  borderRadius: kDefaultBorderRadiusAll),
              child: ListTile(
                leading: Image.asset(
                  "lib/assets/image/carbon.png",
                  width: 36,
                  height: 36,
                ),
                title: Text("Carbon"),
                subtitle: Text("Isi"),
                trailing: _dbController.stockStatus.isEmpty
                    ? SizedBox(
                        height: 36,
                        width: 36,
                        child: CircularProgressIndicator(
                          color: MainColor.getColor(2),
                        ))
                    : Text(
                        _dbController.stockStatus[1].filledQty[3].toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildRegistrationDashboard(BuildContext context) {
    DashboardScreenController _dbController =
        Provider.of<DashboardScreenController>(context);
    AppConfig _appConfig = Provider.of<AppConfig>(context);
    return Container(
      color: Colors.white30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Center(
              child: Text(
                "Pending Registrasi Tabung",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MainColor.getColor(7)),
              ),
            ),
          ),
          Expanded(
              child: _dbController.unregisteredCylinder.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                      color: MainColor.getColor(2),
                    ))
                  : ListView(
                      children: _dbController.unregisteredCylinder.map((e) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 140,
                            decoration: BoxDecoration(
                                borderRadius: kDefaultBorderRadiusAll,
                                color: MainColor.getColor(1)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: e.gasContent == GasContent.FILLED
                                      ? Image.asset(
                                          "lib/assets/image/${e.gasType.name.toLowerCase()}.png",
                                          width: 36,
                                          height: 36,
                                        )
                                      : Image.asset(
                                          "lib/assets/image/${e.gasType.name.toLowerCase()}-empty-white.png",
                                          width: 36,
                                          height: 36,
                                        ),
                                  title: Text(e.gasId),
                                  subtitle: Text(e.gasName),
                                  trailing: PopupMenuButton(
                                      onSelected: (value) async {
                                        final app_pass =
                                            await _appConfig.getPass();
                                        final pass = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              var passs;
                                              return Dialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    color: Colors.white,
                                                    height: 160,
                                                    width: 200,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        children: [
                                                          vSpace(10),
                                                          Text(
                                                              "Enter Admin Password"),
                                                          CustomTextField(
                                                            obscureText: true,
                                                            onChanged: (p0) =>
                                                                passs = p0,
                                                          ),
                                                          vSpace(20),
                                                          CButton(
                                                              buttonColor:
                                                                  MainColor
                                                                      .brandColor,
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context,
                                                                    passs);
                                                              })
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });

                                        if (pass != app_pass) {
                                          cSnackbar(
                                              context, "Password Salah!", 1);
                                          return;
                                        }
                                        if (value == 0) {
                                          await _dbController
                                              .approveRegistration(e.gasId);
                                          cSnackbar(
                                              context, "Approve Success", 1);
                                        } else {
                                          await _dbController
                                              .deleteRegistration(e.gasId);
                                          cSnackbar(
                                              context, "Delete Success", 1);
                                        }
                                      },
                                      itemBuilder: (ctx) => [
                                            _buildPopupMenuItem(
                                                'Approve',
                                                Icons.done_outline,
                                                Options.approve.index),
                                            _buildPopupMenuItem(
                                                'Delete',
                                                Icons
                                                    .disabled_by_default_rounded,
                                                Options.delete.index),
                                          ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 58.0),
                                  child: Text(
                                      "Registered at : ${convertToIndDate(e.dateRegistered)}"),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 58.0, top: 4),
                                  child: Text("by : ${e.registor}"),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ))
        ],
      ),
    );
  }

  _buildLocationDashboard(BuildContext context) {
    DashboardScreenController _dbController =
        Provider.of<DashboardScreenController>(context);
    return Container(
      color: Colors.white38,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Text(
              "List Tabung Kosong",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MainColor.getColor(7)),
            ),
          ),
          Container(
              height: getW(context),
              width: double.infinity,
              child: DataTable(
                columnSpacing: 0,
                headingRowColor: WidgetStatePropertyAll(MainColor.getColor(8)),
                columns: [
                  DataColumn(
                    label: Text(
                      "Location",
                      style:
                          TextStyle(fontSize: 10, color: MainColor.getColor(0)),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "C2H2",
                      style:
                          TextStyle(fontSize: 10, color: MainColor.getColor(0)),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "N2",
                      style:
                          TextStyle(fontSize: 10, color: MainColor.getColor(0)),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "O2",
                      style:
                          TextStyle(fontSize: 10, color: MainColor.getColor(0)),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "CO2",
                      style:
                          TextStyle(fontSize: 10, color: MainColor.getColor(0)),
                    ),
                  ),
                ],
                rows: _dbController.stockStatus.map((e) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(e.location),
                      ),
                      DataCell(
                        Text('${e.emptyQty[0]}'),
                      ),
                      DataCell(
                        Text('${e.emptyQty[1]}'),
                      ),
                      DataCell(
                        Text('${e.emptyQty[2]}'),
                      ),
                      DataCell(
                        Text('${e.emptyQty[3]}'),
                      ),
                    ],
                  );
                }).toList(),
              )),
        ],
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(title),
          ),
        ],
      ),
    );
  }
}
