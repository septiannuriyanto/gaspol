import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:gaspol/controller/home_screen_controller.dart';
import 'package:gaspol/controller/page_controller.dart';
import 'package:gaspol/controller/switches_controller.dart';
import 'package:gaspol/view/components/atomic/widget_props.dart';
import 'package:gaspol/view/components/themes/colors.dart';
import 'package:gaspol/view/components/themes/constants.dart';
import 'package:gaspol/view/components/themes/layouts.dart';
import 'package:gaspol/view/screens/issuing_screen/issuing_screen.dart';
import 'package:gaspol/view/screens/receiving_screen/receiving_screen.dart';
import 'package:gaspol/view/screens/stocks_screen/stock_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  List<Widget> childWidget = [
    StockScreen(),
    ReceivingScreen(),
    IssuingScreen()
  ];

  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    PageNumController _page = Provider.of(context);

    return Scaffold(
      backgroundColor: MainColor.getColor(0),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MainColor.brandColor,
        foregroundColor: Colors.black,
        title: Image.asset(
          'lib/assets/image/gas-cylinder.png',
          height: 30,
          width: 30,
        ),
      ),
      body: childWidget[_page.pagenumber],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        animationDuration: Durations.medium1,
        color: Colors.white,
        buttonBackgroundColor: MainColor.getColor(0),
        backgroundColor: Colors.transparent,
        items: [
          Icon(Icons.home_filled, color: MainColor.getColor(9)),
          Icon(Icons.local_shipping, color: MainColor.brandColor),
          Icon(Icons.shopping_bag, color: MainColor.brandColor)
        ],
        onTap: (value) {
          _page.changePage(value);
        },
      ),
    );
  }
}
