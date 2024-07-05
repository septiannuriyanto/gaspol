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
import 'package:gaspol/view/components/widgets/custom_button.dart';
import 'package:gaspol/view/components/widgets/custom_textfield.dart';
import 'package:gaspol/view/components/widgets/glassmorphism.dart';
import 'package:gaspol/view/dialogs/custom_snackbar.dart';
import 'package:gaspol/view/screens/issuing_screen/issuing_screen.dart';
import 'package:gaspol/view/screens/receiving_screen/receiving_screen.dart';
import 'package:gaspol/view/screens/stocks_screen/stock_screen.dart';
import 'package:gaspol/view/screens/stocktaking_screen/stocktaking_screen.dart';
import 'package:gaspol/view/screens/update_version_screen/update_version_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageNumController _page = Provider.of(context);
    DashboardScreenController _dbController =
        Provider.of<DashboardScreenController>(context);
    AppConfig _appConfig = Provider.of<AppConfig>(context);
    // checkisNewest(_appConfig.isNewestVersion(), context);

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
                ),
                Visibility(
                  visible:
                      _dbController.dashboardMode == DashboardMode.REGISTRATION,
                  child: IconButton(
                    icon: Icon(Icons.verified_user_outlined),
                    onPressed: () async {
                      final app_pass = await _appConfig.getPass();
                      final pass = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            var passs;
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: Colors.white,
                                  height: 160,
                                  width: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        vSpace(10),
                                        Text("Enter Admin Password"),
                                        CustomTextField(
                                          obscureText: true,
                                          onChanged: (p0) => passs = p0,
                                        ),
                                        vSpace(20),
                                        CButton(
                                            buttonColor: MainColor.brandColor,
                                            onPressed: () {
                                              Navigator.pop(context, passs);
                                            })
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });

                      if (pass != app_pass) {
                        cSnackbar(context, "Password Salah!", 1);
                        return;
                      }
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return StockTakingScreen();
                      }));
                      cSnackbar(context, "Welcome", 1);
                    },
                  ),
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
