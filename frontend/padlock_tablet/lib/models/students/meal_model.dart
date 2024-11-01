class MealModel {
  final String date;
  final List<String> menu;
  final List<String> allergy;
  final String calories;

  MealModel({
    required this.date,
    required this.menu,
    required this.allergy,
    required this.calories,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      date: json['date'] as String,
      menu: List<String>.from(json['menu']),
      allergy: List<String>.from(json['allergy']),
      calories: json['calories'] as String,
    );
  }
}
