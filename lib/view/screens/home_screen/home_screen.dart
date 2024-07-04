import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:gaspol/controller/app_config.dart';
import 'package:gaspol/controller/home_screen_controller.dart';
import 'package:gaspol/controller/page_controller.dart';
import 'package:gaspol/controller/switches_controller.dart';
import 'package:gaspol/view/components/atomic/widget_props.dart';
import 'package:gaspol/view/components/themes/colors.dart';
import 'package:gaspol/view/components/themes/constants.dart';
import 'package:gaspol/view/components/themes/layouts.dart';
import 'package:gaspol/view/components/widgets/glassmorphism.dart';
import 'package:gaspol/view/screens/issuing_screen/issuing_screen.dart';
import 'package:gaspol/view/screens/receiving_screen/receiving_screen.dart';
import 'package:gaspol/view/screens/stocks_screen/stock_screen.dart';
import 'package:gaspol/view/screens/update_version_screen/update_version_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  List<Widget> childWidget = [
    StockScreen(),
    ReceivingScreen(),
    IssuingScreen()
  ];

  int _page = 0;

  checkisNewest(Future<bool> fun, BuildContext context) async {
    bool isnewest = await fun;
    if (isnewest == false) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return UpdateVersionScreen();
      }));
    }
  }

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    PageNumController _page = Provider.of(context);
    DashboardScreenController _dbController =
        Provider.of<DashboardScreenController>(context);
    AppConfig _appConfig = Provider.of<AppConfig>(context);
    checkisNewest(_appConfig.isNewestVersion(), context);

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
            appBar: AppBar(
              title: Center(
                  child: Image.asset(
                'lib/assets/image/gaspol-icon.png',
                height: 30,
                color: Colors.white,
              )),
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: Colors.white),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh_rounded),
                  onPressed: () {
                    checkisNewest(_appConfig.isNewestVersion(), context);
                    _dbController.loadData();
                  },
                )
              ],
            ),
            drawer: Drawer(),
            body: childWidget[_page.pagenumber],
            bottomNavigationBar: CurvedNavigationBar(
              key: _bottomNavigationKey,
              animationDuration: Durations.medium1,
              color: Colors.white54,
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
          ),
        ),
      ],
    );
  }
}
