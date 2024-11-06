import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/teacher/mainScreen/title_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class TeaAttendanceCheckWidget extends StatefulWidget {
  const TeaAttendanceCheckWidget({super.key});

  @override
  State<TeaAttendanceCheckWidget> createState() =>
      _TeaAttendanceCheckWidgetState();
}

class _TeaAttendanceCheckWidgetState extends State<TeaAttendanceCheckWidget> {
  final List<String> students = [
    "정지원",
    "정석영",
    "홍수인",
    "김성원",
    "윤보은",
    "이주희",
    "이승민",
    "강도원"
  ];
  int selectedIndex = 0;
  DateTime _focusedDay = DateTime(2024, 11, 1);

  Map<DateTime, String> attendanceData = {
    DateTime(2024, 11, 1): "출석",
    DateTime(2024, 11, 4): "출석",
    DateTime(2024, 11, 5): "출석",
    DateTime(2024, 11, 6): "출석",
    DateTime(2024, 11, 7): "결석",
    DateTime(2024, 11, 8): "출석",
    DateTime(2024, 11, 11): "출석",
    DateTime(2024, 11, 12): "출석",
    DateTime(2024, 11, 13): "결석",
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, bottom: 30),
      child: Column(
        children: [
          const TitleWidget(title: '우리반 출석현황'),
          const SizedBox(height: 15),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 학생 목록
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          '   우리반 학생',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                students[index],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: selectedIndex == index
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                              trailing: selectedIndex == index
                                  ? Icon(Icons.check, color: AppColors.black)
                                  : null,
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(
                    width: 50, thickness: 1, color: AppColors.grey),
                // 달력 및 출결 현황을 Row로 배치
                Expanded(
                  flex: 5,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 달력
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            const Text(
                              '    2024년 11월',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: _buildAttendanceCalendar(),
                            ),
                            SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      // 출결 현황 요약
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: _buildAttendanceSummary(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 출결 현황 요약
  Widget _buildAttendanceSummary() {
    int presentDays =
        attendanceData.values.where((status) => status == "출석").length;
    int lateDays =
        attendanceData.values.where((status) => status == "지각").length;
    int absentDays =
        attendanceData.values.where((status) => status == "결석").length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "${students[selectedIndex]}학생",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "의 출결현황",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Column(
          children: [
            _buildAttendanceStatus("출석", presentDays, AppColors.successGreen),
            SizedBox(
              height: 10,
            ),
            _buildAttendanceStatus("지각/조퇴", lateDays, AppColors.yellow),
            SizedBox(
              height: 10,
            ),
            _buildAttendanceStatus("결석", absentDays, AppColors.errorRed),
          ],
        ),
      ],
    );
  }

  Widget _buildAttendanceStatus(String status, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        children: [
          CircleAvatar(radius: 5, backgroundColor: color),
          const SizedBox(width: 5),
          Text("$status  $count일", style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // TableCalendar 위젯을 사용하여 달력 표시
  Widget _buildAttendanceCalendar() {
    return TableCalendar(
      firstDay: DateTime(2024, 11, 1),
      lastDay: DateTime(2024, 11, 30),
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.month,
      headerVisible: false,
      daysOfWeekVisible: true,
      availableGestures: AvailableGestures.none,
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.transparent, // 오늘 날짜 강조 제거
        ),
        outsideDaysVisible: false,
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          // 주말일 경우 회색으로 표시
          if (day.weekday == DateTime.saturday ||
              day.weekday == DateTime.sunday) {
            return Center(
              child: Text(
                '${day.day}',
                style: TextStyle(color: AppColors.grey),
              ),
            );
          }
          // 평일일 경우 출석 현황을 반영한 색상으로 표시
          return _buildCalendarDay(day);
        },
        todayBuilder: (context, day, focusedDay) {
          // 오늘 날짜도 특별히 강조하지 않고, 출석 현황과 같은 방식으로 표시
          return _buildCalendarDay(day);
        },
      ),
    );
  }

  Widget _buildCalendarDay(DateTime day) {
    final attendanceStatus = attendanceData.entries
        .firstWhere(
          (entry) => isSameDay(entry.key, day),
          orElse: () => MapEntry(day, ""), // 기본 상태로 빈 값 제공
        )
        .value;

    Color backgroundColor;

    switch (attendanceStatus) {
      case "출석":
        backgroundColor = AppColors.successGreen;
        break;
      case "지각":
        backgroundColor = AppColors.yellow;
        break;
      case "결석":
        backgroundColor = AppColors.errorRed;
        break;
      default:
        backgroundColor = Colors.grey.shade200; // 기본 색상 (예: 회색)
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.all(4.0),
        child: CircleAvatar(
          radius: 15,
          backgroundColor: backgroundColor,
          child: Text(
            '${day.day}',
            style: TextStyle(
              color:
                  attendanceStatus.isEmpty ? AppColors.black : AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
