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
  GasType gasType;
  String gasId;
  String gasName;
  DateTime dateRegistered;
  String registor = "User";
  String location;
  RegisterStatus registerStatus;
  GasContent gasContent;

  GasCylinder({
    required this.gasId,
    required this.gasName,
    required this.gasType,
    required this.dateRegistered,
    required this.location,
    required this.registerStatus,
    required this.gasContent,
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

  factory GasCylinder.fromMap(Map<String, dynamic> map) {
    return GasCylinder(
      gasId: map['gas_id'],
      gasName: map['gas_name'],
      gasType: GasType.values.firstWhere((e) => e.name == map['gas_type']),
      dateRegistered: DateTime.parse(map['date_registered'].toString()),
      location: map['location'],
      registerStatus: RegisterStatus.values
          .firstWhere((e) => e.name == map['register_status']),
      gasContent:
          GasContent.values.firstWhere((e) => e.name == map['gas_content']),
    );
  }
}
