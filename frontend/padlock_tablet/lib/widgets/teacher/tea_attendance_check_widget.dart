import 'package:flutter/material.dart';
import 'package:padlock_tablet/api/teacher/attendance_api.dart';
import 'package:padlock_tablet/models/teacher/student_info.dart';
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
  List<Student> students = [];
  Map<int, String> attendanceData = {};
  int selectedIndex = 0;
  DateTime _focusedDay = DateTime(2024, 11, 1);

  @override
  void initState() {
    super.initState();
    _fetchStudentList();
    _fetchAttendanceDataForStudent(selectedIndex);
  }

  Future<void> _fetchStudentList() async {
    final fetchedStudents = await AttendanceApi.fetchStudentList();
    setState(() {
      students = fetchedStudents;
    });
  }

  Future<void> _fetchAttendanceDataForStudent(int index) async {
    if (students.isEmpty || index >= students.length) return;

    final fetchedAttendanceData =
        await AttendanceApi.fetchMonthlyAttendance(students[index].id);
    setState(() {
      attendanceData = fetchedAttendanceData;
    });
  }

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
                                students[index].name,
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
                                _fetchAttendanceDataForStudent(index);
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
                            const SizedBox(height: 30),
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

  Widget _buildAttendanceSummary() {
    int presentDays =
        attendanceData.values.where((status) => status == "PRESENT").length;
    int lateDays =
        attendanceData.values.where((status) => status == "LATE").length;
    int absentDays =
        attendanceData.values.where((status) => status == "ABSENT").length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              students.isNotEmpty
                  ? "${students[selectedIndex].name} 학생"
                  : "학생 없음", // 리스트가 비어 있을 때 기본 텍스트
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              "의 출결현황",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Column(
          children: [
            _buildAttendanceStatus("출석", presentDays, AppColors.successGreen),
            const SizedBox(height: 10),
            _buildAttendanceStatus("지각/조퇴", lateDays, AppColors.yellow),
            const SizedBox(height: 10),
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
          color: Colors.transparent,
        ),
        outsideDaysVisible: false,
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          if (day.weekday == DateTime.saturday ||
              day.weekday == DateTime.sunday) {
            return Center(
              child: Text(
                '${day.day}',
                style: TextStyle(color: AppColors.grey),
              ),
            );
          }
          return _buildCalendarDay(day);
        },
        todayBuilder: (context, day, focusedDay) {
          return _buildCalendarDay(day);
        },
      ),
    );
  }

  Widget _buildCalendarDay(DateTime day) {
    final attendanceStatus = attendanceData[day.day];

    Color backgroundColor;
    switch (attendanceStatus) {
      case "PRESENT":
        backgroundColor = AppColors.successGreen;
        break;
      case "LATE":
        backgroundColor = AppColors.yellow;
        break;
      case "ABSENT":
        backgroundColor = AppColors.errorRed;
        break;
      case "UNREPORTED":
        backgroundColor = Colors.grey.shade700;
        break;
      default:
        backgroundColor = Colors.grey.shade200;
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
                  attendanceStatus == null ? AppColors.black : AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
