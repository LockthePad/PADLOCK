import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/teacher/meal_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:padlock_tablet/theme/colors.dart';

class MealCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final List<MealModel> mealData;

  const MealCalendar({
    super.key,
    required this.onDateSelected,
    required this.mealData,
  });

  @override
  _MealCalendarState createState() => _MealCalendarState();
}

class _MealCalendarState extends State<MealCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  MealModel? _getMealForDay(DateTime date) {
    String dateString = date.toString().split(' ')[0].replaceAll('-', '');
    return widget.mealData.firstWhere(
      (meal) => meal.date == dateString,
      orElse: () => MealModel(
        date: dateString,
        menu: [''],
        allergyFood: [],
        calories: '0kcal',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                '${_focusedDay.year}년 ${_focusedDay.month}월',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _showFullMonthMeal(context),
              child: const Text(
                '전체보기',
                style: TextStyle(color: AppColors.darkGrey),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        TableCalendar(
          firstDay: DateTime(_focusedDay.year, _focusedDay.month, 1),
          lastDay: DateTime(_focusedDay.year, _focusedDay.month + 1, 0),
          focusedDay: _focusedDay,
          calendarFormat: CalendarFormat.month,
          headerVisible: false,
          availableGestures: AvailableGestures.none,
          selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            widget.onDateSelected(selectedDay);
          },
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppColors.lilac,
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.navy,
              shape: BoxShape.circle,
            ),
            weekendTextStyle: TextStyle(
              color: AppColors.lilac,
            ),
          ),
        ),
      ],
    );
  }

  void _showFullMonthMeal(BuildContext context) {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 40),
                  Expanded(
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              '${_focusedDay.month}월의 급식',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 10,
                              width: 280,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: AppColors.navy,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          left: 185,
                          top: -10,
                          child: Image(
                            image: const AssetImage('assets/chef.png'),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: ['월', '화', '수', '목', '금']
                    .map((day) => Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            color: AppColors.navy,
                            child: Text(
                              day,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                  ),
                  itemCount: 25,
                  itemBuilder: (context, index) {
                    final weekNumber = index ~/ 5;
                    final weekday = index % 5;

                    final weekStart =
                        firstDay.subtract(Duration(days: firstDay.weekday - 1));
                    final currentDate =
                        weekStart.add(Duration(days: weekNumber * 7 + weekday));

                    final meal = _getMealForDay(currentDate);

                    // 달에 포함되지 않은 날짜는 빈 칸으로 투명하게 표시
                    if (meal != null &&
                        meal.menu.isEmpty &&
                        meal.calories == '0kcal') {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.transparent),
                        ),
                      );
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${currentDate.day}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(height: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: meal?.menu
                                      .map((item) => Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              height: 1.2,
                                            ),
                                            maxLines: 1, // 한 줄로 제한
                                            overflow: TextOverflow.ellipsis,
                                          ))
                                      .toList() ??
                                  [],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
