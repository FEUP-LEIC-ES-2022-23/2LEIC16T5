class SettingsModel {
  String? userID;
  String currency;

  SettingsModel({
    required this.userID,
    required this.currency,
  });

  factory SettingsModel.fromMap(Map<String, dynamic> json) {
    return SettingsModel(
        userID: json['userID'],
        currency: json['currency'],
      );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'currency': currency
    };
  }
}
