import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gaspol/controller/data/mongodb_controller.dart';
import 'package:gaspol/models/appconfig_model.dart';

class AppConfig extends ChangeNotifier {
  AppConfigModel? _appConfigModel;
  AppConfigModel get appConfigModel => _appConfigModel!;

  int _appVersion = 0;
  int get appVersion => _appVersion;

  Future<AppConfigModel> getAppConfig() async {
    return await MongoDatabase.getLatestAppVer();
  }

  Future<String> getPass() async {
    _appConfigModel = await getAppConfig();
    return _appConfigModel!.app_pass!;
  }

  Future<int> getAppVer() async {
    _appConfigModel = await getAppConfig();
    return _appConfigModel!.appVer!;
  }

  Future<bool> isNewestVersion() async {
    AppConfigModel appConfig = await getAppConfig();
    int _server_version = appConfig.appVer!;
    int _this_version = int.parse(dotenv.env['APP_VERSION']!);
    return _server_version <= _this_version;
  }
}
