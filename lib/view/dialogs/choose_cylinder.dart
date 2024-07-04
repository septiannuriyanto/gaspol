import 'package:flutter/material.dart';
import 'package:gaspol/controller/data/mongodb_controller.dart';
import 'package:gaspol/controller/data/receiving_data_controller.dart';
import 'package:gaspol/models/gas_cylinder.dart';
import 'package:gaspol/view/components/atomic/widget_props.dart';
import 'package:gaspol/view/components/themes/colors.dart';
import 'package:gaspol/view/components/widgets/custom_button.dart';
import 'package:gaspol/view/utils/string_formatter.dart';
import 'package:provider/provider.dart';

class ChooseCylinderDialog extends StatefulWidget {
  ChooseCylinderDialog({required this.cylnumber, super.key});

  final String cylnumber;

  @override
  State<ChooseCylinderDialog> createState() => _ChooseCylinderDialogState();
}

class _ChooseCylinderDialogState extends State<ChooseCylinderDialog> {
  bool isLoading = false;

  List<GasType> gastype = [
    GasType.ACETYLENE,
    GasType.CARBON,
    GasType.NITROGEN,
    GasType.OXYGENT,
  ];

  List<Color> chipColor = [
    Colors.red.shade800,
    Colors.limeAccent.shade200,
    Colors.lightBlue.shade100,
    Colors.lightBlueAccent,
  ];

  int? _value = 1;

  int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    asyncQuery();
  }

  asyncQuery() async {
    count = await MongoDatabase.checkCylinderRegistration(widget.cylnumber);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    DataController _dataController = Provider.of<DataController>(context);
    return Visibility(
      visible: count == 0,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: MainColor.getColor(0),
            borderRadius: kDefaultBorderRadiusAll,
          ),
          width: 400,
          height: 350,
          child: Visibility(
            replacement: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                vSpace(20),
                Text("Please Wait"),
              ],
            )),
            visible: !isLoading,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Add New Cylinder Register",
                    style: TextStyle(color: MainColor.getColor(4)),
                  ),
                  vSpace(20),
                  Text(
                    'Number : ${widget.cylnumber}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                  vSpace(20),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: kDefaultBorderRadiusAll,
                        border: Border.all(color: MainColor.getColor(3))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 10,
                        children: List<Widget>.generate(
                          4,
                          (int index) {
                            return ChoiceChip(
                              showCheckmark: true,
                              selectedColor: chipColor[index],
                              backgroundColor: chipColor[index],
                              label: Text(gastype[index].name),
                              selected: _value == index,
                              onSelected: (selected) {
                                setState(() {
                                  _value = selected ? index : null;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  vSpace(40),
                  CButton(
                    onPressed: () async {
                      var newGasCyl = GasCylinder(
                          gasId: widget.cylnumber,
                          gasName:
                              gastype[_value!].name.toLowerCase().capitalize(),
                          gasType: gastype[_value!],
                          dateRegistered: DateTime.now(),
                          location: "SUPPLIER",
                          registerStatus: RegisterStatus.PENDING,
                          gasContent: GasContent.FILLED);
                      setState(() {
                        isLoading = true;
                      });
                      await _dataController.addToCylinderRegister(newGasCyl);
                      await Future.delayed(const Duration(seconds: 0), () {
                        setState(() {
                          isLoading = false;
                          _dataController.searchCylinder();
                        });
                      });

                      Navigator.pop(context, true);
                    },
                    buttonColor: MainColor.brandColor,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      replacement: Dialog(
        child: Container(
          decoration: BoxDecoration(
            color: MainColor.getColor(0),
            borderRadius: kDefaultBorderRadiusAll,
          ),
          width: 400,
          height: 50,
          child: Center(
              child: Text("Cylinder ID ${widget.cylnumber} sudah terdaftar")),
        ),
      ),
    );
  }
}
