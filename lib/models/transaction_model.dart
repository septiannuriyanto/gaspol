import 'package:gaspol/models/gas_cylinder.dart';

class GasTransaction {
  DateTime transDate;
  String documentNumber;
  String from;
  String to;
  TransactionCategory transactionCategory;
  String delegator;
  String receiver;
  List<GasCylinder>? gasCylinder;

  GasTransaction({
    required this.transDate,
    required this.from,
    required this.to,
    required this.transactionCategory,
    required this.delegator,
    required this.receiver,
    required this.documentNumber,
    this.gasCylinder,
  });

  Map<String, dynamic> toMap() {
    return {
      'transaction_date': transDate,
      'doc_num': documentNumber,
      'tx_category': transactionCategory.name,
      'from': from,
      'to': to,
      'delegator': delegator,
      'receiver': receiver,
      'cylinders': gasCylinder!.map((e) {
        return e.gasId;
      }).toList()
    };
  }
}

enum TransactionCategory {
  INCOMING,
  OUTGOING,
  TRANSFER,
}
