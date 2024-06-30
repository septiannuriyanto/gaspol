import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gaspol/controller/data/data_controller.dart';
import 'package:gaspol/controller/data/db_controller.dart';
import 'package:gaspol/controller/page_controller.dart';
import 'package:gaspol/controller/receiving_screen_controller.dart';
import 'package:gaspol/controller/switches_controller.dart';
import 'package:gaspol/view/components/themes/theme_data.dart';
import 'package:provider/provider.dart';

import 'view/screens/home_screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env.development');
  print(dotenv.env['DB_COLLECTION']);
  await MongoDatabase.connect();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PageNumController()),
      ChangeNotifierProvider(create: (_) => SwitchesController()),
      ChangeNotifierProvider(create: (_) => ReceivingScreenController()),
      ChangeNotifierProvider(create: (_) => DataController()),
    ],
    child: GaspolApp(),
  ));
}

class GaspolApp extends StatelessWidget {
  const GaspolApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gaspol',
      theme: customTheme(Brightness.light),
      home: HomeScreen(),
    );
  }
}
