import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/students/meal_model.dart';
import 'package:padlock_tablet/widgets/student/mainScreen/stu_title_widget.dart';
import 'package:padlock_tablet/widgets/student/mealInfoScreen/meal_calendar.dart';
import 'package:padlock_tablet/widgets/student/mealInfoScreen/meal_data.dart';
import 'package:padlock_tablet/widgets/student/mealInfoScreen/meal_detail.dart';

class StuMealinfoWidget extends StatefulWidget {
  const StuMealinfoWidget({super.key});

  @override
  State<StuMealinfoWidget> createState() => _StuMealinfoWidgetState();
}

class _StuMealinfoWidgetState extends State<StuMealinfoWidget> {
  MealModel? _selectedMeal;
  @override
  void initState() {
    super.initState();
    _setTodayMeal();
  }

  void _setTodayMeal() {
    // 오늘 날짜 문자열 생성 (YYYYMMDD 형식)
    DateTime now = DateTime.now();
    String todayString = now.toString().split(' ')[0].replaceAll('-', '');

    // 오늘 날짜의 급식 정보 찾기
    _selectedMeal = testMealData.firstWhere(
      (meal) => meal.date == todayString,
      orElse: () => MealModel(
        date: todayString,
        menu: ['급식 정보가 없습니다.'],
        allergy: [],
        calories: '0kcal',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          const StuTitleWidget(title: '이번달 급식'),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 16,
                child: MealCalendar(
                  onDateSelected: (meal) {
                    setState(() {
                      _selectedMeal = meal;
                    });
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: 1,
                ),
              ),
              Expanded(
                flex: 13,
                child: MealDetailWidget(
                  mealData: _selectedMeal,
                ),
              ),
              // Expanded(
              //   flex: 1,
              //   child: SizedBox(
              //     width: 1,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
