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

  GasCylinder({
    required this.gasId,
    required this.gasName,
    required this.gasType,
    required this.dateRegistered,
    required this.location,
    required this.registerStatus,
  });
}
