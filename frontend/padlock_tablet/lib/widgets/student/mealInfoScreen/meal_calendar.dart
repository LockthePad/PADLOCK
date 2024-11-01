import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/students/meal_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/student/mealInfoScreen/meal_data.dart';

class MealCalendar extends StatefulWidget {
  final Function(MealModel?) onDateSelected;

  const MealCalendar({
    super.key,
    required this.onDateSelected,
  });

  @override
  _MealCalendarState createState() => _MealCalendarState();
}

class _MealCalendarState extends State<MealCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  MealModel? _getMealForDay(DateTime date) {
    String dateString = date.toString().split(' ')[0].replaceAll('-', '');
    return testMealData.firstWhere(
      (meal) => meal.date == dateString,
      orElse: () => MealModel(
        date: dateString,
        menu: ['급식 정보가 없습니다.'],
        allergy: [],
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
              padding: const EdgeInsets.only(
                left: 25,
              ),
              child: Text(
                '${_focusedDay.year}년 ${_focusedDay.month}월',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _showFullMonthMeal(context),
              child: const Text(
                '전체보기',
                style: TextStyle(color: AppColors.black),
              ),
            ),
          ],
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
            widget.onDateSelected(_getMealForDay(selectedDay));
          },
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppColors.paleYellow,
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.yellow,
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
    // 해당 월의 첫 날과 마지막 날 구하기
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    // final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);

    // TableCalendar와 동일한 방식으로 첫 주의 시작일 계산
    // final startWeekday = firstDay.weekday;
    // final prevMonthDays = startWeekday == 7 ? 0 : startWeekday;
    // final startDate = firstDay.subtract(Duration(days: prevMonthDays));

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
              // 상단 타이틀 영역 부분을 다음과 같이 수정
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 40), // 왼쪽 여백
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
                                color: AppColors.yellow,
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
              // Container(
              //   width: double.infinity,
              //   height: 2,
              //   color: AppColors.yellow,
              // ),
              const SizedBox(height: 16),

              // 요일 헤더
              Row(
                children: ['월', '화', '수', '목', '금'] // 주말 제외
                    .map((day) => Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            color: AppColors.yellow,
                            child: Text(
                              day,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),

              // 급식 달력 그리드
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5, // 5일만 표시
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                  ),
                  itemCount: 30, // 5일 x 7주
                  itemBuilder: (context, index) {
                    // 주의 시작일(월요일)을 찾기
                    final weekNumber = index ~/ 5; // 현재 주 번호
                    final weekday = index % 5; // 현재 요일 (0: 월 ~ 4: 금)

                    // 해당 주의 월요일 찾기
                    final weekStart =
                        firstDay.subtract(Duration(days: firstDay.weekday - 1));
                    final currentDate =
                        weekStart.add(Duration(days: weekNumber * 7 + weekday));

                    final isCurrentMonth =
                        currentDate.month == _focusedDay.month;

                    // 이번 달의 날짜가 아닌 경우 빈 컨테이너 반환
                    if (!isCurrentMonth) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                      );
                    }

                    final dateStr =
                        '${currentDate.year}${currentDate.month.toString().padLeft(2, '0')}${currentDate.day.toString().padLeft(2, '0')}';
                    final meal = testMealData.firstWhere(
                      (m) => m.date == dateStr,
                      orElse: () => MealModel(
                        date: dateStr,
                        menu: [],
                        allergy: [],
                        calories: '0kcal',
                      ),
                    );

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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: meal.menu
                                .map((item) => Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        height: 1.2,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ))
                                .toList(),
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
