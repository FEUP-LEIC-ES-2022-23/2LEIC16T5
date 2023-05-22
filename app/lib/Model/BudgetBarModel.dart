class BudgetBarModel {
  String? categoryName;
  String categoryID;
  String userID;
  double? limit;
  double? value;
  int? color;
  int? x;
  double? y;
  bool? onLimit;
  bool? overLimit;
  
  BudgetBarModel({
    this.categoryName,
    required this.categoryID,
    required this.userID,
    this.limit,
    this.value,
    this.color,
  });

  factory BudgetBarModel.fromMap(Map<String, dynamic> json) => BudgetBarModel(
        categoryName: json['categoryName'],
        categoryID: json['categoryID'],
        userID: json['userID'],
        limit: json['limit'].toDouble(),
        color: json['color'].toInt(),
      );
  factory BudgetBarModel.fromMapWithValue(Map<String, dynamic> json) =>
      BudgetBarModel(
          categoryName: json['categoryName'],
          categoryID: json['categoryID'],
          userID: json['userID'],
          limit: json['limit'].toDouble(),
          color: json['color'].toInt(),
          value: json['value'].toDouble());

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'categoryID': categoryID,
      'userID': userID,
      'limit': limit,
      'color': color,
      'value': value
    };
  }
}
