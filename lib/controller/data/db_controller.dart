import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gaspol/controller/data/data_controller.dart';
import 'package:gaspol/models/gas_cylinder.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static Db? db;
  static final DbCollection cylStock =
      db!.collection(dotenv.env['DB_STOCK_COLLECTION']!);

  static Future<void> connect() async {
    try {
      db = await Db.create(dotenv.env['DB_URL']!);
      await db!.open();
      inspect(db);
      var status = await db!.serverStatus();
      print(status);
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> registerCylinder(GasCylinder gas) async {
    try {
      await MongoDatabase.open();
      await cylStock.insert(gas.toMap());
      await MongoDatabase.close();
    } catch (e) {
      print(e);
    }
  }

  static Future<void> open() async {
    try {
      await db!.open();
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> close() async {
    try {
      await db!.close();
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<List<GasCylinder>> fetchAllCylinderList() async {
    List<GasCylinder> cyls = [];
    try {
      await MongoDatabase.open();
      await cylStock.find().forEach((element) {
        cyls.add(GasCylinder.fromMap(element));
      });
      await MongoDatabase.close();
    } catch (e) {
      print(e);
    }

    return cyls;
  }

  static Future<List<GasCylinder>> fetchCylinderListByText(
      String keyword) async {
    List<GasCylinder> cyls = [];
    try {
      await MongoDatabase.open();
      await cylStock.find().forEach((element) {
        cyls.add(GasCylinder.fromMap(element));
      });
      await MongoDatabase.close();
    } catch (e) {
      print(e);
    }

    return cyls;
  }
}
