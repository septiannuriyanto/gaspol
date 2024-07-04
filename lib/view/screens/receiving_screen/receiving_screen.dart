import 'package:dashed_stepper/dashed_stepper.dart';
import 'package:flutter/material.dart';
import 'package:gaspol/controller/data/constants.dart';
import 'package:gaspol/controller/data/receiving_data_controller.dart';
import 'package:gaspol/controller/receiving_screen_controller.dart';

import 'package:gaspol/models/gas_cylinder.dart';
import 'package:gaspol/view/components/atomic/widget_props.dart';
import 'package:gaspol/view/components/themes/colors.dart';
import 'package:gaspol/view/components/themes/constants.dart';
import 'package:gaspol/view/components/themes/layouts.dart';
import 'package:gaspol/view/components/widgets/custom_button.dart';
import 'package:gaspol/view/components/widgets/custom_textfield.dart';
import 'package:gaspol/view/components/widgets/fake_textfield.dart';
import 'package:gaspol/view/dialogs/choose_cylinder.dart';
import 'package:gaspol/view/dialogs/custom_snackbar.dart';
import 'package:gaspol/view/dialogs/input_text_dialog.dart';
import 'package:gaspol/view/dialogs/order_list_dialog.dart';
import 'package:gaspol/view/utils/datetime_formatter.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:timer_controller/timer_controller.dart';

class ReceivingScreen extends StatefulWidget {
  ReceivingScreen({super.key});

  @override
  State<ReceivingScreen> createState() => _ReceivingScreenState();
}

class _ReceivingScreenState extends State<ReceivingScreen>
    with SingleTickerProviderStateMixin {
  final txtCon = TextEditingController();

  final TimerController secondsTimer = TimerController.seconds(1);

  ReceivingScreenController? _controller;
  DataController? _dataController;

  @override
  void dispose() {
    secondsTimer.dispose();
    super.dispose();
  }

  void resetAllReceivingStates() {
    _dataController!.resetAllReceivingStates();
    _controller!.resetUIReceivingStates();
  }

  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<ReceivingScreenController>(context);
    _dataController = Provider.of<DataController>(context);
    return Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Column(
        children: [
          Expanded(
            flex: 0,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FakeTextField(
                      readOnly: _controller!.isSet,
                      prefixIcon: Icons.discount,
                      iconColor: _controller!.isSet == true
                          ? Colors.grey
                          : MainColor.getColor(2),
                      caption: _controller!.poNumber,
                      radius: 8,
                      borderColor: MainColor.getColor(2),
                      onPress: () async {
                        final data = await showGeneralDialog(
                          context: context,
                          barrierColor: Colors.black12
                              .withOpacity(0.6), // Background color
                          barrierDismissible: true,
                          barrierLabel: 'Dialog',
                          transitionDuration: Duration(milliseconds: 400),
                          pageBuilder: (context, __, ___) {
                            return InputTextDialog();
                          },
                        );

                        if (data != null) {
                          print(data);
                          _controller!.changePONumber(data.toString());
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FakeTextField(
                      readOnly: _controller!.isSet,
                      prefixIcon: Icons.calendar_month,
                      iconColor: _controller!.isSet == true
                          ? Colors.grey
                          : MainColor.getColor(2),
                      caption: _controller!.dateReceived == null
                          ? "Input Date"
                          : convertToIndDate(_controller!.dateReceived!),
                      radius: 8,
                      borderColor: MainColor.getColor(2),
                      onPress: () async {
                        final date = await showDatePicker(
                          context: context,
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 3)),
                          lastDate: DateTime.now().add(const Duration(days: 3)),
                        );
                        if (date != null) {
                          _controller!.changeDate(date);
                        }
                      },
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                        color: _controller!.isSet == true
                            ? Colors.grey
                            : MainColor.brandColor,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: MainColor.getColor(0),
                    ),
                  ),
                  onTap: () {
                    bool validate =
                        _controller!.poNumber != "Input PO Number" &&
                            _controller!.dateReceived != null;
                    if (validate == true) {
                      _controller!.lockHeaderData();
                    }
                  },
                ),
              ],
            ),
          ),
          vSpace(10),
          DashedStepper(
            indicatorColor: Colors.lightGreen,
            length: 5,
            step: _controller!.stepper,
            labelStyle: const TextStyle(color: Colors.black),
            labels: const [
              'Input\nPO',
              'Receive\nFilled',
              'Issue\nEmpty',
              'Check\nOut',
              'Done'
            ],
          ),
          vSpace(20),
          _controller!.stepper == 1
              ? Text(
                  "Input Data Order",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              : _controller!.stepper == 2
                  ? Text("Pilih Tabung untuk Diterima",
                      style: TextStyle(fontWeight: FontWeight.bold))
                  : _controller!.stepper == 3
                      ? Text("Pilih Tabung untuk Dikirim",
                          style: TextStyle(fontWeight: FontWeight.bold))
                      : _controller!.stepper == 4
                          ? Column(
                              children: [
                                Text("Summary Order",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                vSpace(20)
                              ],
                            )
                          : Text("Order Complete",
                              style: TextStyle(fontWeight: FontWeight.bold)),
          Visibility(
            visible: _dataController!.processType != ProcessType.CHECKOUT &&
                _dataController!.processType != ProcessType.DONE,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TimerControllerListener(
                listener: (context, value) {
                  if (value.status == TimerStatus.finished) {
                    _dataController!.searchCylinder();
                  }
                },
                controller: secondsTimer,
                child: CustomTextField(
                  textCapitalization: TextCapitalization.words,
                  txtController: txtCon,
                  readonly: !_controller!.isSet,
                  prefixIcon: Icon(Icons.search_sharp),
                  hint: "Search Cylinder Number",
                  onChanged: (p0) async {
                    _dataController!.setCylinderNumber(p0);
                    _dataController!
                        .changeAutoCompleteState(AutoCompleteType.WAITING);
                    secondsTimer.restart();
                  },
                ),
              ),
            ),
          ),
          _dataController!.processType == ProcessType.RECEIVING
              ?

              //LISTVIEW WIDGET FOR RECEIVING PROCESS
              Expanded(
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Column(
                          children: _dataController!.cylinderToReceive.map((e) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration:
                                    BoxDecoration(color: MainColor.getColor(1)),
                                child: ListTile(
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
                                    trailing: IconButton(
                                      onPressed: () {
                                        _dataController!
                                            .removeCylinderFromReceivingList(
                                                e.gasId);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                    )),
                              ),
                            );
                          }).toList(),
                        ),
                        Visibility(
                          visible: _dataController!.cylinderNumber.isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              padding: kDefaultEdgeInsets,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: MainColor.getColor(1)),
                                  color: Colors.white,
                                  borderRadius: kDefaultBorderRadiusAll),
                              width: getW(context),
                              height: (_dataController!.autoCompleteType ==
                                          AutoCompleteType.ADD_ITEM) ||
                                      (_dataController!.autoCompleteType ==
                                          AutoCompleteType.WAITING)
                                  ? 86
                                  : _dataController!.autoCompleteType ==
                                          AutoCompleteType.DISPLAY_LIST
                                      ? 256
                                      : 0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildAutoCompleteWidget(
                                    string: _dataController!.cylinderNumber,
                                    search: _dataController!.autoCompleteType,
                                    cyls: _dataController!.filteredCylinderList,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : _dataController!.processType == ProcessType.RETURNING
                  ?
                  //LISTVIEW WIDGET FOR RETURN PROCESS
                  Expanded(
                      child: SingleChildScrollView(
                        child: Stack(
                          children: [
                            Column(
                              children:
                                  _dataController!.cylinderToReturn.map((e) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.red.shade100),
                                    child: ListTile(
                                        leading:
                                            e.gasContent == GasContent.FILLED
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
                                        trailing: IconButton(
                                          onPressed: () {
                                            _dataController!
                                                .removeCylinderFromReturnList(
                                                    e.gasId);
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                          ),
                                        )),
                                  ),
                                );
                              }).toList(),
                            ),
                            Visibility(
                              visible:
                                  _dataController!.cylinderNumber.isNotEmpty,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Container(
                                  padding: kDefaultEdgeInsets,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: MainColor.getColor(1)),
                                      color: Colors.white,
                                      borderRadius: kDefaultBorderRadiusAll),
                                  width: getW(context),
                                  height: (_dataController!.autoCompleteType ==
                                              AutoCompleteType.ADD_ITEM) ||
                                          (_dataController!.autoCompleteType ==
                                              AutoCompleteType.WAITING)
                                      ? 86
                                      : _dataController!.autoCompleteType ==
                                              AutoCompleteType.DISPLAY_LIST
                                          ? 256
                                          : 0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      _buildAutoCompleteWidget(
                                        string: _dataController!.cylinderNumber,
                                        search:
                                            _dataController!.autoCompleteType,
                                        cyls: _dataController!
                                            .filteredCylinderList,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : _dataController!.processType == ProcessType.CHECKOUT
                      ? Expanded(
                          child: DataTable(
                            headingRowColor: WidgetStateColor.resolveWith(
                                (states) => MainColor.getColor(1)),
                            columns: [
                              DataColumn(
                                  label: Text(
                                "Tipe\nGas",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              )),
                              DataColumn(
                                  label: Text(
                                "Qty\nReceive",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              )),
                              DataColumn(
                                  label: Text(
                                "Qty\nReturn",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ))
                            ],
                            rows: [
                              DataRow(cells: [
                                DataCell(
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.red.shade800,
                                        borderRadius: kDefaultBorderRadiusAll),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4),
                                      child: Text(
                                        "Acetylene",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(_dataController!.cylinderToReceive
                                    .where(
                                        (e) => e.gasType == GasType.ACETYLENE)
                                    .toList()
                                    .length
                                    .toString())),
                                DataCell(Text(_dataController!.cylinderToReturn
                                    .where(
                                        (e) => e.gasType == GasType.ACETYLENE)
                                    .toList()
                                    .length
                                    .toString())),
                              ]),
                              DataRow(cells: [
                                DataCell(
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlue.shade200,
                                        borderRadius: kDefaultBorderRadiusAll),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4),
                                      child: Text(
                                        "Nitrogen",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(_dataController!.cylinderToReceive
                                    .where((e) => e.gasType == GasType.NITROGEN)
                                    .toList()
                                    .length
                                    .toString())),
                                DataCell(Text(_dataController!.cylinderToReturn
                                    .where((e) => e.gasType == GasType.NITROGEN)
                                    .toList()
                                    .length
                                    .toString())),
                              ]),
                              DataRow(cells: [
                                DataCell(
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue.shade600,
                                        borderRadius: kDefaultBorderRadiusAll),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4),
                                      child: Text(
                                        "Oxygent",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(_dataController!.cylinderToReceive
                                    .where((e) => e.gasType == GasType.OXYGENT)
                                    .toList()
                                    .length
                                    .toString())),
                                DataCell(Text(_dataController!.cylinderToReturn
                                    .where((e) => e.gasType == GasType.OXYGENT)
                                    .toList()
                                    .length
                                    .toString())),
                              ]),
                              DataRow(cells: [
                                DataCell(
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.green.shade400,
                                        borderRadius: kDefaultBorderRadiusAll),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4),
                                      child: Text(
                                        "Carbon",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(_dataController!.cylinderToReceive
                                    .where((e) => e.gasType == GasType.CARBON)
                                    .toList()
                                    .length
                                    .toString())),
                                DataCell(Text(_dataController!.cylinderToReturn
                                    .where((e) => e.gasType == GasType.CARBON)
                                    .toList()
                                    .length
                                    .toString())),
                              ]),
                              DataRow(
                                  color: WidgetStateColor.resolveWith(
                                      (states) => MainColor.getColor(1)),
                                  cells: [
                                    DataCell(
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4),
                                        child: Text(
                                          "Total",
                                          style: TextStyle(),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(_dataController!
                                              .cylinderToReceive.length
                                              .toString()),
                                          InkWell(
                                            child: Icon(
                                              Icons.zoom_out_map_outlined,
                                              color: MainColor.brandColor,
                                            ),
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return OrderListDialog(
                                                        gasCyl: _dataController!
                                                            .cylinderToReceive);
                                                  });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(_dataController!
                                              .cylinderToReturn.length
                                              .toString()),
                                          InkWell(
                                            child: Icon(
                                              Icons.zoom_out_map_outlined,
                                              color: MainColor.brandColor,
                                            ),
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return OrderListDialog(
                                                        gasCyl: _dataController!
                                                            .cylinderToReturn);
                                                  });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
                            ],
                          ),

                          // child: Column(
                          //   children: [
                          //     Expanded(
                          //       flex: 0,
                          //       child: Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           crossAxisAlignment: CrossAxisAlignment.center,
                          //           children: [
                          //             Expanded(
                          //                 child: Center(
                          //                     child: Text("Botol Diterima"))),
                          //             Expanded(
                          //                 child:
                          //                     Center(child: Text("Botol Dikirim")))
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //     Expanded(
                          //       child: Row(
                          //         children: [
                          //           Expanded(
                          //             child: Padding(
                          //               padding: const EdgeInsets.all(8.0),
                          //               child: Container(
                          //                 decoration: BoxDecoration(
                          //                   border: Border.all(
                          //                       color: MainColor.getColor(2)),
                          //                 ),
                          //                 height: double.infinity,
                          //                 child: ListView(
                          //                   children: _dataController
                          //                       .cylinderToReceive
                          //                       .map((e) {
                          //                     return ListTile(
                          //                       title: Text(e.gasId),
                          //                       subtitle: Text(
                          //                         e.gasName,
                          //                         style: TextStyle(fontSize: 12),
                          //                       ),
                          //                       leading: e.gasContent ==
                          //                               GasContent.FILLED
                          //                           ? Image.asset(
                          //                               "lib/assets/image/${e.gasType.name.toLowerCase()}.png",
                          //                               width: 36,
                          //                               height: 36,
                          //                             )
                          //                           : Image.asset(
                          //                               "lib/assets/image/${e.gasType.name.toLowerCase()}-empty-white.png",
                          //                               width: 36,
                          //                               height: 36,
                          //                             ),
                          //                     );
                          //                   }).toList(),
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //           Expanded(
                          //             child: Padding(
                          //               padding: const EdgeInsets.all(8.0),
                          //               child: Container(
                          //                 decoration: BoxDecoration(
                          //                     border: Border.all(
                          //                         color: MainColor.getColor(2))),
                          //                 height: double.infinity,
                          //                 child: ListView(
                          //                   children: _dataController
                          //                       .cylinderToReturn
                          //                       .map((e) {
                          //                     return ListTile(
                          //                       title: Text(e.gasId),
                          //                       subtitle: Text(
                          //                         e.gasName,
                          //                         style: TextStyle(fontSize: 12),
                          //                       ),
                          //                       leading: e.gasContent ==
                          //                               GasContent.FILLED
                          //                           ? Image.asset(
                          //                               "lib/assets/image/${e.gasType.name.toLowerCase()}.png",
                          //                               width: 36,
                          //                               height: 36,
                          //                             )
                          //                           : Image.asset(
                          //                               "lib/assets/image/${e.gasType.name.toLowerCase()}-empty-white.png",
                          //                               width: 36,
                          //                               height: 36,
                          //                             ),
                          //                     );
                          //                   }).toList(),
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        )
                      : Expanded(
                          child:
                              Center(child: Text("Please wait to return.."))),
          Visibility(
            visible: _dataController!.processType != ProcessType.DONE,
            child: Expanded(
                flex: 0,
                child: CButton(
                    buttonColor: MainColor.brandColor,
                    caption: "Submit",
                    onPressed: () async {
                      if (_dataController!.processType ==
                          ProcessType.RETURNING) {
                        if (_dataController!.cylinderToReturn.length > 0) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            text: 'Anda yakin untuk Return?',
                            confirmBtnText: 'Yes',
                            cancelBtnText: 'No',
                            confirmBtnColor: Colors.green,
                            onConfirmBtnTap: () {
                              _controller!.addStepper();
                              _dataController!.proceedToCheckout();
                              Navigator.pop(context, true);
                              cSnackbar(context, "Sukses Menyimpan Data!", 2);
                            },
                          );
                        } else {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            text: 'Data Kosong',
                            confirmBtnText: 'Ok',
                            confirmBtnColor: Colors.green,
                            onConfirmBtnTap: () {
                              Navigator.pop(context, true);
                            },
                          );
                        }
                      } else if (_dataController!.processType ==
                          ProcessType.RECEIVING) {
                        if (_dataController!.cylinderToReceive.length > 0) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            text: 'Anda yakin untuk Receive?',
                            confirmBtnText: 'Yes',
                            cancelBtnText: 'No',
                            confirmBtnColor: Colors.green,
                            onConfirmBtnTap: () {
                              _controller!.addStepper();
                              _dataController!.proceedToReturn();
                              Navigator.pop(context, true);
                              cSnackbar(context, "Sukses Menyimpan Data!", 2);
                            },
                          );
                        } else {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            text: 'Data Kosong',
                            confirmBtnText: 'Ok',
                            confirmBtnColor: Colors.green,
                            onConfirmBtnTap: () {
                              Navigator.pop(context, true);
                            },
                          );
                        }
                      } else {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          text: 'Anda yakin untuk checkout transaksi?',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          confirmBtnColor: Colors.green,
                          onConfirmBtnTap: () async {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: Container(
                                      color: Colors.white,
                                      width: 100,
                                      height: 200,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator(),
                                              vSpace(10),
                                              Text("Sending Data"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                            await _dataController!.checkoutReceiving(
                                _controller!.poNumber,
                                _controller!.dateReceived!);

                            _controller!.addStepper();
                            Navigator.pop(context, true);
                            cSnackbar(context, "Sukses Menyimpan Data!", 2);
                            await Future.delayed(const Duration(seconds: 2));
                            resetAllReceivingStates();
                          },
                        );
                      }
                    })),
          )
        ],
      ),
    );
  }

  _buildAutoCompleteWidget(
      {String? string, AutoCompleteType? search, List<GasCylinder>? cyls}) {
    if (search == AutoCompleteType.WAITING) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (search == AutoCompleteType.DISPLAY_LIST) {
      return Builder(builder: (context) {
        DataController _dataController = Provider.of<DataController>(context);
        if (_dataController!.searchResult == SearchResult.EXACT) {
          return SizedBox(
            height: 230,
            child: ListView(
                children: cyls!.map((e) {
              return ListTile(
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
                trailing: InkWell(
                  child: Icon(
                    Icons.add_circle_outline_rounded,
                    color: MainColor.brandColor,
                  ),
                  onTap: () async {
                    final data;
                    if (_dataController!.processType == ProcessType.RECEIVING) {
                      data = await _dataController!.addCylinderToReceive(e);
                    } else {
                      data = await _dataController!.addCylinderToReturn(e);
                    }
                    if (data != 'success') {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          text: data,
                          title: "Duplicate");
                    }
                    _dataController!.resetCylinderNumber();
                    txtCon.clear();
                  },
                ),
              );
            }).toList()),
          );
        } else {
          return Column(
            children: [
              SizedBox(
                height: 64,
                child: InkWell(
                  child: Container(
                    color: MainColor.getColor(0),
                    child: InkWell(
                      child: ListTile(
                        title: Text(
                          "Add Cylinder number $string",
                          style: TextStyle(
                              fontSize: 14, color: MainColor.brandColor),
                        ),
                        trailing: Icon(
                          Icons.add_box_outlined,
                          color: MainColor.brandColor,
                        ),
                      ),
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return ChooseCylinderDialog(
                                cylnumber: string!,
                              );
                            });
                      },
                    ),
                  ),
                  onTap: () {},
                ),
              ),
              SizedBox(
                height: 160,
                child: ListView(
                    children: cyls!.map((e) {
                  return ListTile(
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
                    trailing: InkWell(
                      child: Icon(
                        Icons.add_circle_outline_rounded,
                        color: MainColor.brandColor,
                      ),
                      onTap: () {
                        if (_dataController!.processType ==
                            ProcessType.RECEIVING) {
                          _dataController!.addCylinderToReceive(e);
                        } else {
                          _dataController!.addCylinderToReturn(e);
                        }
                        _dataController!.resetCylinderNumber();
                        txtCon.clear();
                      },
                    ),
                  );
                }).toList()),
              ),
            ],
          );
        }
      });
    } else if (search == AutoCompleteType.ADD_ITEM) {
      return Builder(builder: (context) {
        return InkWell(
          child: Container(
            color: MainColor.getColor(0),
            child: InkWell(
              child: ListTile(
                title: Text(
                  "Add Cylinder number $string",
                  style: TextStyle(fontSize: 14, color: MainColor.brandColor),
                ),
                trailing: Icon(
                  Icons.add_box_outlined,
                  color: MainColor.brandColor,
                ),
              ),
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return ChooseCylinderDialog(
                        cylnumber: string!,
                      );
                    });
              },
            ),
          ),
          onTap: () {},
        );
      });
    } else {
      return Container();
    }
  }
}
