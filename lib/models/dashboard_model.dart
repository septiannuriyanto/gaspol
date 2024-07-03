class DashboardModel {
  String location;
  List<int> filledQty;
  List<int> emptyQty;

  DashboardModel({
    required this.location,
    required this.filledQty,
    required this.emptyQty,
  });

  factory DashboardModel.fromObjectMap(Map<String, dynamic> obj) {
    return DashboardModel(
      location: obj["location"],
      filledQty: obj["filled"],
      emptyQty: obj["empty"],
    );
  }
}
