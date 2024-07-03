import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gaspol/controller/data/data_controller.dart';
import 'package:gaspol/models/gas_cylinder.dart';
import 'package:gaspol/models/transaction_model.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:collection';

class MongoDatabase {
  static Db? db;

  static final DbCollection cylStock =
      db!.collection(dotenv.env['DB_STOCK_COLLECTION']!);
  static final DbCollection cylTrans =
      db!.collection(dotenv.env['DB_TRANS_COLLECTION']!);

  static Future<void> connect() async {
    try {
      db = await Db.create(dotenv.env['DB_URL']!);
      if (db!.isConnected) await db!.close();
      await db!.open();
      inspect(db);
      var status = await db!.serverStatus();
      print(status);
    } catch (e) {
      log('Error Connection $e');
    }
  }

  static Future<void> registerCylinder(GasCylinder gas) async {
    try {
      await cylStock.insert(gas.toMap());
    } catch (e) {
      print(e);
    }
  }

  static Future<void> transactionProcess(GasTransaction transaction) async {
    try {
      await cylTrans.insert(transaction.toMap());
      for (var element in transaction.gasCylinder!) {
        await cylStock.update(where.eq('gas_id', element.gasId),
            ModifierBuilder().set('location', transaction.to));
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> dbOpen() async {
    try {
      await db!.open();
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> dbClose() async {
    try {
      await db!.close();
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<List<GasCylinder>> fetchAllCylinderList() async {
    List<GasCylinder> _cyls = [];
    try {
      await cylStock.find({
        'register_status': 'REGISTERED',
        'gas_content': 'FILLED',
        'location': 'SUPPLIER'
      }).forEach((element) {
        _cyls.add(GasCylinder.fromMap(element));
      });
    } catch (e) {
      print(e);
    }

    return _cyls;
  }

  static Future<List<GasCylinder>> fetchEmptyCylinderList() async {
    final DbCollection cylStock =
        db!.collection(dotenv.env['DB_STOCK_COLLECTION']!);
    List<GasCylinder> _cyls = [];
    try {
      await cylStock.find({
        'register_status': 'REGISTERED',
        'gas_content': 'EMPTY',
        'location': 'SM'
      }).forEach((element) {
        _cyls.add(GasCylinder.fromMap(element));
      });
    } catch (e) {
      print(e);
    }

    return _cyls;
  }
}
