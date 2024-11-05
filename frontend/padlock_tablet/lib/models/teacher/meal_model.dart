class MealModel {
  final String date;
  final List<String> menu;
  final List<String> allergyFood;
  final String calories;

  MealModel({
    required this.date,
    required this.menu,
    required this.allergyFood,
    required this.calories,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      date: json['date'] as String,
      menu: (json['menu'] as String).split(',').map((e) => e.trim()).toList(),
      allergyFood: (json['allergyFood'] as String)
          .split(',')
          .map((e) => e.trim())
          .toList(),
      calories: json['calorie'] as String,
    );
  }

  factory MealModel.empty(String date) {
    return MealModel(
      date: date,
      menu: ['급식 정보가 없습니다.'],
      allergyFood: [],
      calories: '0 Kcal',
    );
  }
}
