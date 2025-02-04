import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gaspol/controller/app_config.dart';
import 'package:gaspol/controller/data/issuing_data_controller.dart';
import 'package:gaspol/controller/data/mongodb_controller.dart';
import 'package:gaspol/controller/data/receiving_data_controller.dart';
import 'package:gaspol/controller/home_screen_controller.dart';
import 'package:gaspol/controller/issuing_screen_controller.dart';
import 'package:gaspol/controller/page_controller.dart';
import 'package:gaspol/controller/receiving_screen_controller.dart';
import 'package:gaspol/controller/switches_controller.dart';
import 'package:gaspol/view/components/themes/theme_data.dart';
import 'package:gaspol/view/screens/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env.development');
  await MongoDatabase.connect();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppConfig()),
        ChangeNotifierProvider(create: (_) => PageNumController()),
        ChangeNotifierProvider(create: (_) => SwitchesController()),
        ChangeNotifierProvider(create: (_) => DashboardScreenController()),
        ChangeNotifierProvider(create: (_) => ReceivingScreenController()),
        ChangeNotifierProvider(create: (_) => IssuingScreenController()),
        ChangeNotifierProvider(create: (_) => IssuingDataController()),
        ChangeNotifierProvider(create: (_) => DataController()),
      ],
      child: GaspolApp(),
    ),
  );
}

class GaspolApp extends StatelessWidget {
  const GaspolApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gaspol',
      theme: customTheme(Brightness.light),
      home: SplashScreen(),
    );
  }
}
