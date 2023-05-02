class SavingsModel {
  String? userID;
  String? name;
  num? value;
  num? total;
  DateTime? targetDate;

  SavingsModel(
      {required this.userID,
      required this.name,
      required this.value,
      required this.total,
      this.targetDate});

  factory SavingsModel.fromMap(Map<String, dynamic>? json) => SavingsModel(
        userID: json!['userID'],
        name: json['name'],
        value: json['value'],
        total: json['total'],
        targetDate: (json['targetDate'] == null)? null : DateTime.fromMillisecondsSinceEpoch(json['targetDate']),
      );

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'name': name,
      'value': value,
      'total': total,
      'targetDate': (targetDate == null)? null : targetDate!.millisecondsSinceEpoch,
    };
  }
}