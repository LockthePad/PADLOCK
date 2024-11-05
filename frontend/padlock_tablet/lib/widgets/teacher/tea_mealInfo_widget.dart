import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:padlock_tablet/api/common/mealInfo_api.dart';
import 'package:padlock_tablet/models/teacher/meal_model.dart';
import 'package:padlock_tablet/widgets/teacher/mainScreen/title_widget.dart';
import 'package:padlock_tablet/widgets/teacher/mealInfoScreen/meal_calendar.dart';
import 'package:padlock_tablet/widgets/teacher/mealInfoScreen/meal_detail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TeaMealinfoWidget extends StatefulWidget {
  const TeaMealinfoWidget({super.key});

  @override
  State<TeaMealinfoWidget> createState() => _TeaMealinfoWidgetState();
}

class _TeaMealinfoWidgetState extends State<TeaMealinfoWidget> {
  late MealModel _selectedMeal;
  final storage = const FlutterSecureStorage();
  List<MealModel> _monthlyMeals = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final today = DateFormat('yyyyMMdd').format(DateTime.now());
    _selectedMeal = MealModel(
      date: today,
      menu: ['급식 정보 불러오는 중.'],
      allergyFood: [],
      calories: '0kcal',
    );
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _setMonthMeal();
    await _fetchSelectedMealDetail(DateTime.now());
  }

  Future<void> _setMonthMeal() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String? accessToken = await storage.read(key: 'accessToken');
      String? classroomId = await storage.read(key: 'classroomId');

      if (accessToken != null && accessToken.isNotEmpty) {
        final yearMonth = DateFormat('yyyyMM').format(DateTime.now());
        final mealList = await MealinfoApi.fetchMonthMeal(
          token: accessToken,
          yearMonth: yearMonth,
          classroomId: classroomId!,
        );

        final updatedMeals = mealList
            .map((meal) => MealModel(
                  date: meal['date'] ?? '',
                  menu: meal['menu']?.split(',') ?? ['급식 정보가 없습니다.'],
                  allergyFood: [],
                  calories: '0kcal',
                ))
            .toList();

        setState(() {
          _monthlyMeals = updatedMeals;
          _isLoading = false;
        });
      } else {
        print('No access token available');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading meal data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchSelectedMealDetail(DateTime selectedDate) async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      String? classroomId = await storage.read(key: 'classroomId');

      if (accessToken != null && accessToken.isNotEmpty) {
        final formattedDate = DateFormat('yyyyMMdd').format(selectedDate);

        final mealDetail = await MealinfoApi.fetchDailyMeal(
          token: accessToken,
          today: formattedDate,
          classroomId: classroomId!,
        );

        setState(() {
          _selectedMeal = MealModel(
            date: mealDetail['date'],
            menu: mealDetail['menu'].split(','),
            allergyFood: mealDetail['allergyFood'].split(','),
            calories: mealDetail['calorie'],
          );
        });
      }
    } catch (e) {
      print('Error loading meal detail: $e');
      final formattedDate = DateFormat('yyyyMMdd').format(selectedDate);
      setState(() {
        _selectedMeal = MealModel(
          date: formattedDate,
          menu: ['급식 정보가 없습니다.'],
          allergyFood: [],
          calories: '0kcal',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, bottom: 30),
      child: Column(
        children: [
          const TitleWidget(title: '이번달 급식'),
          const SizedBox(height: 15),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  flex: 14,
                  child: MealCalendar(
                    onDateSelected: (selectedDate) async {
                      await _fetchSelectedMealDetail(selectedDate);
                    },
                    mealData: _monthlyMeals,
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(width: 1),
                ),
                Expanded(
                  flex: 13,
                  child: MealDetailWidget(
                    mealData: _selectedMeal,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
