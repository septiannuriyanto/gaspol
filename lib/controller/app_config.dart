import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gaspol/controller/data/mongodb_controller.dart';

class AppConfig extends ChangeNotifier {
  Future<bool> isNewestVersion() async {
    int _server_version = await MongoDatabase.getLatestAppVer();
    int _this_version = int.parse(dotenv.env['APP_VERSION']!);
    return _server_version <= _this_version;
  }
}
