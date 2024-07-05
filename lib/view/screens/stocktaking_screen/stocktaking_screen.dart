import 'package:flutter/material.dart';
import 'package:gaspol/controller/data/constants.dart';
import 'package:gaspol/controller/data/mongodb_controller.dart';
import 'package:gaspol/controller/home_screen_controller.dart';
import 'package:gaspol/models/gas_cylinder.dart';
import 'package:gaspol/view/components/atomic/widget_props.dart';
import 'package:gaspol/view/components/themes/colors.dart';
import 'package:gaspol/view/components/widgets/custom_textfield.dart';
import 'package:gaspol/view/components/widgets/glassmorphism.dart';
import 'package:gaspol/view/dialogs/location_bottomsheet.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

class StockTakingScreen extends StatefulWidget {
  const StockTakingScreen({super.key});

  @override
  State<StockTakingScreen> createState() => _StockTakingScreenState();
}

class _StockTakingScreenState extends State<StockTakingScreen> {
  DashboardScreenController? _dataController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _dataController!.loadAllCylinder());
  }

  @override
  Widget build(BuildContext context) {
    _dataController = Provider.of<DashboardScreenController>(context);
    return Stack(
      children: [
        Image.asset(
          height: cHeight(context),
          width: cWidth(context),
          'lib/assets/image/bg-blue3.jpg',
          fit: BoxFit.cover,
        ),
        GlassMorphism(
          blur: 10,
          color: Colors.black,
          opacity: 0.2,
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Stock Location Adjustment",
                      style: TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      enable: true,
                      textCapitalization: TextCapitalization.words,
                      prefixIcon: Icon(Icons.search_sharp),
                      hint: "Search Cylinder Number",
                      onChanged: (p0) {
                        _dataController!.filterCylinder(p0);
                      },
                    ),
                  ),
                  // Expanded(
                  //     child: ListView(
                  //         children: _dataController!.filteredCylinder.map((e) {
                  //   return ListTile(
                  //     leading: e.gasContent == GasContent.FILLED
                  //         ? Image.asset(
                  //             "lib/assets/image/${e.gasType.name.toLowerCase()}.png",
                  //             width: 36,
                  //             height: 36,
                  //           )
                  //         : Image.asset(
                  //             "lib/assets/image/${e.gasType.name.toLowerCase()}-empty-white.png",
                  //             width: 36,
                  //             height: 36,
                  //           ),
                  //     title: Text(
                  //       e.gasId,
                  //       style: TextStyle(fontWeight: FontWeight.w500),
                  //     ),
                  //     subtitle: Text(e.location),
                  //     trailing: IconButton(
                  //         onPressed: () async {
                  //           final data = await showModalBottomSheet(
                  //               context: context,
                  //               builder: (context) {
                  //                 return Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Container(
                  //                     decoration: BoxDecoration(),
                  //                     height: cWidth(context),
                  //                     child: ListView(
                  //                       children: Locations.map((e) {
                  //                         return Padding(
                  //                           padding: const EdgeInsets.all(8.0),
                  //                           child: InkWell(
                  //                             child: Container(
                  //                               decoration: BoxDecoration(
                  //                                   borderRadius:
                  //                                       kDefaultBorderRadiusAll,
                  //                                   color:
                  //                                       MainColor.getColor(3)),
                  //                               height: 60,
                  //                               child: Center(
                  //                                   child: Text(
                  //                                 e,
                  //                                 style: TextStyle(
                  //                                     color: Colors.white),
                  //                               )),
                  //                             ),
                  //                             onTap: () {
                  //                               Navigator.pop(context, e);
                  //                             },
                  //                           ),
                  //                         );
                  //                       }).toList(),
                  //                     ),
                  //                   ),
                  //                 );
                  //               });

                  //           if (data != null) {
                  //             await MongoDatabase.changeCylinderLocation(
                  //                 e.gasId, data);
                  //           }
                  //         },
                  //         icon: Icon(Icons.edit_note_rounded)),
                  //   );
                  // }).toList())),

                  Expanded(
                    child: GroupedListView<GasCylinder, String>(
                      elements: _dataController!.filteredCylinder,

                      groupBy: (element) => element.location,
                      groupSeparatorBuilder: (String location) => Container(
                        width: double.infinity,
                        height: 50,
                        color: Colors.white38,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(location),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      itemBuilder: (context, GasCylinder e) {
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
                          title: Text(
                            e.gasId,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            '${e.gasType.name} | ${e.gasContent.name} - ${e.location} ',
                            style: TextStyle(fontSize: 12),
                          ),
                          trailing: IconButton(
                              onPressed: () async {
                                final data = await showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return LocationBottomsheet();
                                    });

                                if (data != null) {
                                  await MongoDatabase.changeCylinderLocation(
                                      e.gasId, data);
                                }
                              },
                              icon: Icon(Icons.edit_note_rounded)),
                        );
                      },
                      itemComparator: (item1, item2) =>
                          item1.gasId.compareTo(item2.gasId), // optional
                      // useStickyGroupSeparators: true, // optional
                      // floatingHeader: true, // optional
                      order: GroupedListOrder.ASC, // optional

                      // footer: Text("Widget at the bottom of list"), // optional
                    ),
                  ),
                ],
              ))),
        ),
      ],
    );
  }
}
