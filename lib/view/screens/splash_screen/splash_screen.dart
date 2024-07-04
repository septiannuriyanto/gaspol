import 'package:flutter/material.dart';
import 'package:gaspol/controller/app_config.dart';
import 'package:gaspol/controller/home_screen_controller.dart';
import 'package:gaspol/view/components/atomic/widget_props.dart';
import 'package:gaspol/view/components/themes/colors.dart';
import 'package:gaspol/view/screens/home_screen/home_screen.dart';
import 'package:gaspol/view/screens/update_version_screen/update_version_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool? isNewest;
    DashboardScreenController _dbController =
        Provider.of<DashboardScreenController>(context);
    AppConfig _appConfig = Provider.of<AppConfig>(context);
    return FutureBuilder(
        future: Future.wait(
          [
            Future.delayed(const Duration(seconds: 2), () async {
              isNewest = await _appConfig.isNewestVersion();

              if (isNewest == false) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return UpdateVersionScreen();
                }));
                return;
              }
            }),

            _dbController.loadData(),

            Future.delayed(const Duration(seconds: 4), () async {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return HomeScreen();
              }));
            }),

            // timer(context),
          ],
        ),
        builder: (context, snapshot) {
          return Stack(
            children: [
              Image.asset(
                height: cHeight(context),
                width: cWidth(context),
                'lib/assets/image/bg-blue3.jpg',
                fit: BoxFit.cover,
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  children: [
                    Expanded(
                      child: SizedBox(),
                    ),
                    Container(
                      height: 80,
                      width: cWidth(context),
                      child: Image.asset(
                        height: 50,
                        'lib/assets/image/gaspol-landscape-trans.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "A Product by Scalar Coding",
                        style: TextStyle(
                            fontSize: 12, color: MainColor.brandColor),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  Future timer(BuildContext context) async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return HomeScreen();
    }));
  }
}
