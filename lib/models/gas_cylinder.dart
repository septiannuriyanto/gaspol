import 'package:mongo_dart/mongo_dart.dart';

enum GasType {
  ACETYLENE,
  OXYGENT,
  NITROGEN,
  CARBON,
}

enum RegisterStatus {
  REGISTERED,
  PENDING,
}

enum GasContent { FILLED, EMPTY }

List<String> Location = [
  "SUPPLIER",
  "SM",
  "TRACK",
  "WHEEL",
  "SSE",
];

class GasCylinder {
  String? jobsite;
  GasType gasType;
  String gasId;
  String gasName;
  DateTime dateRegistered;
  String? registor;
  String location;
  RegisterStatus registerStatus;
  GasContent gasContent;

  GasCylinder({
    this.jobsite,
    required this.gasId,
    required this.gasName,
    required this.gasType,
    required this.dateRegistered,
    required this.location,
    required this.registerStatus,
    required this.gasContent,
    this.registor,
  });

  Map<String, dynamic> toMap() {
    return {
      'gas_type': gasType.name,
      'gas_id': gasId,
      'gas_name': gasName,
      'date_registered': dateRegistered,
      'registor': registor,
      'location': location,
      'register_status': registerStatus.name,
      'gas_content': gasContent.name
    };
  }

  factory GasCylinder.fromMap(Map<String, dynamic> mapOfCyl) {
    return GasCylinder(
      gasType: GasType.values.firstWhere((e) => e.name == mapOfCyl['gas_type']),
      gasId: mapOfCyl['gas_id'],
      gasName: mapOfCyl['gas_name'],
      dateRegistered: DateTime.parse(mapOfCyl['date_registered'].toString()),
      registor: mapOfCyl['registor'],
      location: mapOfCyl['location'],
      registerStatus: RegisterStatus.values
          .firstWhere((e) => e.name == mapOfCyl['register_status']),
      gasContent: GasContent.values
          .firstWhere((e) => e.name == mapOfCyl['gas_content']),
    );
  }
}
