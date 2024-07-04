import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gaspol/controller/data/receiving_data_controller.dart';
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
      // while (db!.state == ConnectionState.active) {
      //   await Future.delayed(Duration(milliseconds: 100));
      // }
      // if (db!.isConnected) return;
      // await db!.close();
      // await db!.open();
      // return;

      if (db!.isConnected) await db!.close();
      await db!.open(secure: true);
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

  static Future<void> getGasCountAllType() async {
    final pipeline = AggregationPipelineBuilder()
        .addStage(Group(id: Field('gas_type'), fields: {'count': Sum(1)}))
        .build();
    try {
      final res = await cylStock.modernAggregate(pipeline).toList();
      res.forEach(print);
    } catch (e) {
      print(e);
    }
  }

  static getLocationAggregate() async {
    List<String> locs = [];
    final locationPipeline = AggregationPipelineBuilder()
        .addStage(Group(id: Field('location')))
        .build();

    try {
      final res = await cylStock.modernAggregate(locationPipeline).toList();
      print(res);
      for (var element in res) {
        locs.add(element["_id"]);
      }

      print(locs);
    } catch (e) {
      print(e);
    }
  }

  static Future<Map<String, dynamic>> getFilledGasCountAllTypeByLocation(
      String location) async {
    Map<String, dynamic> result = {};
    result.clear();
    final filledPipeline = AggregationPipelineBuilder()
        .addStage(Match(where
            .eq('location', location)
            .and(where.eq('gas_content', 'FILLED'))
            .map['\$query']))
        .addStage(Group(id: Field('gas_type'), fields: {'total': Sum(1)}))
        .build();

    final emptyPipeline = AggregationPipelineBuilder()
        .addStage(Match(where
            .eq('location', location)
            .and(where.eq('gas_content', 'EMPTY'))
            .map['\$query']))
        .addStage(Group(id: Field('gas_type'), fields: {'total': Sum(1)}))
        .build();
    try {
      final filledRes = await cylStock.modernAggregate(filledPipeline).toList();
      final emptyRes = await cylStock.modernAggregate(emptyPipeline).toList();

      //Normalization
      List<String> availablegas = [];
      List<String> unavailablegas = [];
      Map<dynamic, dynamic> filledGas = {};
      Map<dynamic, dynamic> emptyGas = {};

      //TAKE CARE OF FILLED ELEMENTS
      for (var element in filledRes) {
        availablegas.add(element["_id"]);
      }

      for (var element in GasType.values) {
        if (!availablegas.contains(element.name)) {
          unavailablegas.add(element.name);
        }
      }

      if (unavailablegas.isNotEmpty) {
        for (var element in unavailablegas) {
          filledRes.add({"_id": element, "total": 0});
        }
      }

      for (var element in filledRes) {
        var entry = {element["_id"]: element["total"]};
        filledGas.addEntries(entry.entries);
      }

      //RESET
      availablegas.clear();
      unavailablegas.clear();

      //TAKE CARE OF EMPTY ELEMENTS
      for (var element in emptyRes) {
        availablegas.add(element["_id"]);
      }

      for (var element in GasType.values) {
        if (!availablegas.contains(element.name)) {
          unavailablegas.add(element.name);
        }
      }

      if (unavailablegas.isNotEmpty) {
        for (var element in unavailablegas) {
          emptyRes.add({"_id": element, "total": 0});
        }
      }

      for (var element in emptyRes) {
        var entry = {element["_id"]: element["total"]};
        emptyGas.addEntries(entry.entries);
      }

      //check
      result = {
        "location": location,
        "filled": [
          filledGas["ACETYLENE"],
          filledGas["NITROGEN"],
          filledGas["OXYGENT"],
          filledGas["CARBON"]
        ],
        "empty": [
          emptyGas["ACETYLENE"],
          emptyGas["NITROGEN"],
          emptyGas["OXYGENT"],
          emptyGas["CARBON"]
        ]
      };
    } catch (e) {
      print(e);
    }
    return result;
  }

  static Future<void> getGasCount(GasType gastype, String location) async {
    final pipeline = AggregationPipelineBuilder()
        .addStage(
          Match(where
              .eq('gas_type', gastype.name)
              .and(where.eq('location', location))
              .map['\$query']),
        )
        .addStage(Group(id: Field('gas_type'), fields: {'count': Sum(1)}))
        .build();
    try {
      final res = await cylStock.modernAggregate(pipeline).toList();
      res.forEach(print);
    } catch (e) {
      print(e);
    }
  }

  static Future<void> transactionProcess(GasTransaction transaction) async {
    try {
      await cylTrans.insert(transaction.toMap());
      for (var element in transaction.gasCylinder!) {
        await cylStock.update(
            where.eq('gas_id', element.gasId),
            ModifierBuilder().set('location', transaction.to).set(
                'gas_content',
                transaction.transactionCategory == TransactionCategory.TRANSFER
                    ? "EMPTY"
                    : "FILLED"));
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> approvePendingRegistration(String gasId) async {
    try {
      await cylStock.update(where.eq('gas_id', gasId),
          ModifierBuilder().set('register_status', 'REGISTERED'));
    } catch (e) {
      print(e);
    }
  }

  static Future<void> deletePendingRegistration(String gasId) async {
    try {
      await cylStock.deleteOne({"gas_id": gasId});
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

  static Future<List<GasCylinder>> fetchAllCylinderList(String source) async {
    List<GasCylinder> _cyls = [];
    try {
      await cylStock.find({
        'register_status': 'REGISTERED',
        'gas_content': 'FILLED',
        'location': source
      }).forEach((element) {
        _cyls.add(GasCylinder.fromMap(element));
      });
    } catch (e) {
      print(e);
    }

    return _cyls;
  }

  static Future<List<GasCylinder>> fetchUnregisteredCylinderList() async {
    List<GasCylinder> _cyls = [];
    try {
      await cylStock.find({
        'register_status': 'PENDING',
      }).forEach((element) {
        _cyls.add(GasCylinder.fromMap(element));
      });
    } catch (e) {
      print(e);
    }

    return _cyls;
  }

  static Future<int> checkCylinderRegistration(String gasId) async {
    List<GasCylinder> _cyls = [];
    try {
      await cylStock.find({
        'gas_id': gasId,
      }).forEach((element) {
        _cyls.add(GasCylinder.fromMap(element));
      });
    } catch (e) {
      print(e);
    }

    return _cyls.length;
  }

  static Future<List<GasCylinder>> fetchEmptyCylinderList(String source) async {
    final DbCollection cylStock =
        db!.collection(dotenv.env['DB_STOCK_COLLECTION']!);
    List<GasCylinder> _cyls = [];
    try {
      await cylStock.find({
        'register_status': 'REGISTERED',
        'gas_content': 'EMPTY',
        'location': source
      }).forEach((element) {
        _cyls.add(GasCylinder.fromMap(element));
      });
    } catch (e) {
      print(e);
    }

    return _cyls;
  }
}
