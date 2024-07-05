class AppConfigModel {
  int? appVer;
  DateTime? releaseDate;
  String? desc;
  String? app_pass;

  AppConfigModel({this.appVer, this.releaseDate, this.desc, this.app_pass});

  factory AppConfigModel.fromMap(Map<String, dynamic> map) {
    return AppConfigModel(
        appVer: map['appver'],
        releaseDate: map['date'],
        desc: map['desc'],
        app_pass: map['app_pass']);
  }
}
