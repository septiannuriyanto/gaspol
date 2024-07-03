import 'package:flutter/material.dart';
import 'package:gaspol/models/gas_cylinder.dart';
import 'package:gaspol/view/components/atomic/widget_props.dart';
import 'package:gaspol/view/components/themes/colors.dart';
import 'package:gaspol/view/components/widgets/custom_textfield.dart';

class OrderListDialog extends StatefulWidget {
  OrderListDialog({required this.gasCyl, super.key});
  List<GasCylinder> gasCyl;

  @override
  State<OrderListDialog> createState() => _OrderListDialogState();
}

class _OrderListDialogState extends State<OrderListDialog> {
  bool isDescending = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: cHeight(context),
        width: cWidth(context),
        decoration: BoxDecoration(
          color: MainColor.getColor(0),
          borderRadius: kDefaultBorderRadiusAll,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                  flex: 0,
                  child: Text(
                    "Order List",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
              vSpace(10),
              //WILL BE AVAILABLE LATER
              // Expanded(
              //     flex: 0,
              //     child: Row(
              //       children: [
              //         Expanded(
              //           child: CustomTextField(
              //             prefixIcon: Icon(Icons.search),
              //             onChanged: (p0) {
              //               setState(() {
              //                 widget.gasCyl.where(
              //                     (element) => element.gasId.contains(p0));
              //               });
              //             },
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.only(left: 8.0),
              //           child: InkWell(
              //             child: Icon(Icons.sort_by_alpha_outlined),
              //             onTap: () {
              //               print(isDescending);

              //               setState(() {
              //                 if (isDescending == false) {
              //                   isDescending = true;
              //                   widget.gasCyl
              //                       .sort((a, b) => a.gasId.compareTo(b.gasId));
              //                 } else {
              //                   isDescending = false;
              //                   widget.gasCyl
              //                       .sort((b, a) => b.gasId.compareTo(a.gasId));
              //                 }
              //               });
              //             },
              //           ),
              //         ),
              //       ],
              //     )),
              Expanded(
                  child: ListView.builder(
                itemCount: widget.gasCyl.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading:
                          widget.gasCyl[index].gasContent == GasContent.FILLED
                              ? Image.asset(
                                  "lib/assets/image/${widget.gasCyl[index].gasType.name.toLowerCase()}.png",
                                  width: 36,
                                  height: 36,
                                )
                              : Image.asset(
                                  "lib/assets/image/${widget.gasCyl[index].gasType.name.toLowerCase()}-empty-white.png",
                                  width: 36,
                                  height: 36,
                                ),
                      title: Text(widget.gasCyl[index].gasId),
                      subtitle: Text(
                          '${widget.gasCyl[index].gasName} ( ${widget.gasCyl[index].gasContent.name} )'),
                    ),
                  );
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
