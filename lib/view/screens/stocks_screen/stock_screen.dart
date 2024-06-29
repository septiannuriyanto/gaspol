import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaspol/controller/switches_controller.dart';
import 'package:gaspol/view/components/themes/colors.dart';
import 'package:gaspol/view/components/themes/layouts.dart';
import 'package:provider/provider.dart';

import '../../components/atomic/widget_props.dart';
import '../../components/themes/constants.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SwitchesController _switch = Provider.of<SwitchesController>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, User",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              "Hari ini : Senin, 24 Juni 2024",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.list,
                      color: MainColor.brandColor,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.location_on_outlined,
                        color: MainColor.getColor(1))),
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.onetwothree_rounded,
                        color: MainColor.getColor(1))),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(kDefaultPadding),
              child: Row(
                children: [
                  Text(
                    "Stock Ready",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MainColor.getColor(4)),
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(_switch.tabungIsiDesc),
                  ),
                  CupertinoSwitch(
                    activeColor: MainColor.brandColor,
                    value: _switch.tabungIsiSwitch,
                    onChanged: (value) {
                      _switch.toggleTabungIsi(value);
                    },
                  )
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(
                minHeight: getW(context),
                minWidth: getW(context),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: kDefaultBorderRadiusAll,
                  boxShadow: [kDefaultBoxShadow]),
              child: Padding(
                padding: EdgeInsets.all(kDefaultPadding),
                child: Column(
                  children: [
                    Container(
                      margin: kDefaultEdgeInsets,
                      decoration: BoxDecoration(
                          color: MainColor.getColor(1),
                          borderRadius: kDefaultBorderRadiusAll),
                      child: ListTile(
                        leading: Image.asset(
                          "lib/assets/image/acetylene.png",
                          width: 36,
                          height: 36,
                        ),
                        title: Text("Acetylene"),
                        subtitle: Text("Isi"),
                        trailing: Text(
                          "10",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      margin: kDefaultEdgeInsets,
                      color: MainColor.getColor(1),
                      child: ListTile(
                        leading: Image.asset(
                          "lib/assets/image/oxygent.png",
                          width: 36,
                          height: 36,
                        ),
                        title: Text("Oxygen"),
                        subtitle: Text("Isi"),
                        trailing: Text(
                          "56",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      margin: kDefaultEdgeInsets,
                      color: MainColor.getColor(1),
                      child: ListTile(
                        leading: Image.asset(
                          "lib/assets/image/nitrogen.png",
                          width: 36,
                          height: 36,
                        ),
                        title: Text("Nitrogen"),
                        subtitle: Text("Isi"),
                        trailing: Text(
                          "5",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      margin: kDefaultEdgeInsets,
                      color: MainColor.getColor(1),
                      child: ListTile(
                        leading: Image.asset(
                          "lib/assets/image/carbon.png",
                          width: 36,
                          height: 36,
                        ),
                        title: Text("Carbon"),
                        subtitle: Text("Isi"),
                        trailing: Text(
                          "7",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
