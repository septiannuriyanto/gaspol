import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
}
