import 'dart:async';

import 'package:dashed_stepper/dashed_stepper.dart';
import 'package:flutter/material.dart';
import 'package:gaspol/controller/data/data_controller.dart';
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
import 'package:gaspol/view/utils/datetime_formatter.dart';
import 'package:gaspol/view/utils/string_formatter.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class ReceivingScreen extends StatefulWidget {
  ReceivingScreen({super.key});

  @override
  State<ReceivingScreen> createState() => _ReceivingScreenState();
}

class _ReceivingScreenState extends State<ReceivingScreen> {
  String _poNumber = '';

  final txtCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ReceivingScreenController _controller =
        Provider.of<ReceivingScreenController>(context);
    DataController _dataController = Provider.of<DataController>(context);
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
                      readOnly: _controller.isSet,
                      prefixIcon: Icons.discount,
                      iconColor: _controller.isSet == true
                          ? Colors.grey
                          : MainColor.getColor(2),
                      caption: _controller.poNumber,
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
                          _controller.changePONumber(data.toString());
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FakeTextField(
                      readOnly: _controller.isSet,
                      prefixIcon: Icons.calendar_month,
                      iconColor: _controller.isSet == true
                          ? Colors.grey
                          : MainColor.getColor(2),
                      caption: _controller.dateReceived == null
                          ? "Input Date"
                          : convertToIndDate(_controller.dateReceived!),
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
                          _controller.changeDate(date);
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
                        color: _controller.isSet == true
                            ? Colors.grey
                            : MainColor.brandColor,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: MainColor.getColor(0),
                    ),
                  ),
                  onTap: () {
                    bool validate = _controller.poNumber != "Input PO Number" &&
                        _controller.dateReceived != null;
                    if (validate == true) {
                      _controller.lockHeaderData();
                    }
                  },
                ),
              ],
            ),
          ),
          vSpace(10),
          DashedStepper(
            indicatorColor: Colors.lightGreen,
            length: 4,
            step: _controller.stepper,
            labelStyle: const TextStyle(color: Colors.black),
            labels: const [
              'Input\nPO',
              'Receive\nFilled',
              'Issue\nEmpty',
              'Check\nOut'
            ],
          ),
          vSpace(20),
          _controller.stepper == 1
              ? Text(
                  "Pilih Tabung untuk Diterima",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              : _controller.stepper == 2
                  ? Text("Pilih Tabung untuk Dikirim",
                      style: TextStyle(fontWeight: FontWeight.bold))
                  : vSpace(0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              textCapitalization: TextCapitalization.words,
              txtController: txtCon,
              readonly: !_controller.isSet,
              prefixIcon: Icon(Icons.search_sharp),
              hint: "Search Cylinder Number",
              onChanged: (p0) {
                _dataController.setCylinderNumber(p0);
                _dataController.searchCylinder(p0);
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: _dataController.cylinderToReceive.map((e) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration:
                              BoxDecoration(color: MainColor.getColor(1)),
                          child: ListTile(
                              leading: Image.asset(
                                "lib/assets/image/${e.gasType.name.toLowerCase()}.png",
                                width: 36,
                                height: 36,
                              ),
                              title: Text(e.gasId),
                              subtitle: Text(e.gasName),
                              trailing: IconButton(
                                onPressed: () {
                                  _dataController.removeCylinder(e.gasId);
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
                    visible: _dataController.cylinderNumber.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        padding: kDefaultEdgeInsets,
                        decoration: BoxDecoration(
                            border: Border.all(color: MainColor.getColor(1)),
                            color: Colors.white,
                            borderRadius: kDefaultBorderRadiusAll),
                        width: getW(context),
                        height: _dataController.searchCommand ==
                                SearchCommand.ADD_ITEM
                            ? 86
                            : _dataController.searchCommand ==
                                    SearchCommand.DISPLAY_LIST
                                ? 256
                                : 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildAddNewCylinderWidget(
                              string: _dataController.cylinderNumber,
                              search: _dataController.searchCommand,
                              cyls: _dataController.filteredCylinderList,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              flex: 0,
              child: CButton(
                  buttonColor: MainColor.brandColor,
                  caption: "Submit",
                  onPressed: () {
                    if (_dataController.cylinderToReceive.length > 0) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        text: 'Anda yakin?',
                        confirmBtnText: 'Yes',
                        cancelBtnText: 'No',
                        confirmBtnColor: Colors.green,
                        onConfirmBtnTap: () {
                          _controller.addStepper();
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
                  }))
        ],
      ),
    );
  }

  _buildAddNewCylinderWidget(
      {String? string, SearchCommand? search, List<GasCylinder>? cyls}) {
    if (search == SearchCommand.DISPLAY_LIST) {
      return Builder(builder: (context) {
        DataController _dataController = Provider.of<DataController>(context);
        return SizedBox(
          height: 230,
          child: ListView(
              children: cyls!.map((e) {
            return ListTile(
              leading: Image.asset(
                "lib/assets/image/${e.gasType.name.toLowerCase()}.png",
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
                  _dataController.addCylinder(e);
                  _dataController.resetCylinderNumber();
                  txtCon.clear();
                },
              ),
            );
          }).toList()),
        );
      });
    } else if (search == SearchCommand.ADD_ITEM) {
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
