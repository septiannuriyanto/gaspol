import 'package:gaspol/models/gas_cylinder.dart';

class GasTransaction {
  DateTime transDate;
  String cylNumber;
  GasType gasType;
  String documentType;
  String documentNumber;
  String from;
  String to;
  TransactionCategory transactionCategory;
  int qty;
  String delegator;
  String receiver;

  GasTransaction({
    required this.transDate,
    required this.cylNumber,
    required this.gasType,
    required this.from,
    required this.to,
    required this.transactionCategory,
    required this.qty,
    required this.delegator,
    required this.receiver,
    required this.documentNumber,
    required this.documentType,
  });
}

enum TransactionCategory {
  INCOMING,
  OUTGOING,
}
