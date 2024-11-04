import 'package:flutter/material.dart';
import 'package:padlock_tablet/api/teacher/counseling_api.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CounselingCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final double buttonRadius;

  const CounselingCalendar({
    super.key,
    required this.onDateSelected,
    this.buttonRadius = 10.0,
  });

  @override
  _CounselingCalendarState createState() => _CounselingCalendarState();
}

class _CounselingCalendarState extends State<CounselingCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _availableTimes = [];

  // 날짜 선택 시 API를 호출하여 상담 가능 시간 목록을 업데이트하는 함수
  Future<void> _fetchAvailableTimes(String selectedDate) async {
    try {
      print("Fetching available times for $selectedDate"); // 확인 로그
      final data = await CounselingApi.fetchCounselingData(selectedDate);
      print("Fetched data: $data");
      setState(() {
        _availableTimes = data;
      });
    } catch (e) {
      print('Failed to load available times: $e'); // 오류 메시지 출력
    }
  }

  // 상담 시간 상태 토글 함수
  Future<void> _toggleCounselingStatus(int id, int currentStatus) async {
    try {
      bool success = await CounselingApi.toggleCounselingStatus(id);
      if (success) {
        setState(() {
          _availableTimes = _availableTimes.map((timeSlot) {
            if (timeSlot['id'] == id) {
              timeSlot['closed'] = currentStatus == 1 ? 2 : 1;
            }
            return timeSlot;
          }).toList();
        });
      } else {
        print('Failed to toggle counseling status');
      }
    } catch (e) {
      print('Error toggling counseling status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableCalendar(
          firstDay: DateTime(_focusedDay.year, _focusedDay.month, 1),
          lastDay: DateTime(_focusedDay.year, _focusedDay.month + 1, 0),
          focusedDay: _focusedDay,
          calendarFormat: CalendarFormat.month,
          headerVisible: false,
          availableGestures: AvailableGestures.none,
          selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
          onDaySelected: (selectedDay, focusedDay) {
            if (selectedDay
                .isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              String formattedDate =
                  "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";
              print("Selected Date: $formattedDate"); // 로그 확인
              _fetchAvailableTimes(formattedDate);
              widget.onDateSelected(selectedDay);
            }
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
            disabledTextStyle: TextStyle(
              color: AppColors.grey,
            ),
            weekendTextStyle: TextStyle(
              color: AppColors.lilac,
            ),
          ),
        ),
        const SizedBox(height: 30),
        if (_selectedDay != null) ...[
          const Row(
            children: [
              SizedBox(width: 10),
              Text(
                '상담 가능한 시간을 설정해주세요!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildTimeSlotButtons(),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              _buildLegendItem('예약가능', AppColors.navy),
              const SizedBox(width: 10),
              _buildLegendItem('예약불가', AppColors.grey),
              const SizedBox(width: 10),
              _buildLegendItem('이미 예약됨', AppColors.lilac),
            ],
          ),
        ],
      ],
    );
  }

  // 시간 슬롯 버튼 빌드 함수
  Widget _buildTimeSlotButtons() {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 10,
      children: _availableTimes.map((timeSlot) {
        String time = timeSlot['counselAvailableTime'].substring(0, 5);
        int closed = timeSlot['closed'];

        Color backgroundColor;
        Color textColor;
        bool isClickable = false;

        switch (closed) {
          case 1:
            backgroundColor = AppColors.grey;
            textColor = Colors.black;
            isClickable = true;
            break;
          case 2:
            backgroundColor = AppColors.navy;
            textColor = Colors.white;
            isClickable = true;
            break;
          case 3:
            backgroundColor = AppColors.lilac;
            textColor = Colors.black;
            isClickable = false;
            break;
          default:
            backgroundColor = AppColors.grey;
            textColor = Colors.black;
        }

        return GestureDetector(
          onTap: isClickable
              ? () => _toggleCounselingStatus(timeSlot['id'], closed)
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors.navy,
                width: 2,
              ),
            ),
            child: Text(
              time,
              style: TextStyle(fontSize: 15, color: textColor),
            ),
          ),
        );
      }).toList(),
    );
  }

  // 범례 생성 함수
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        CircleAvatar(
          radius: 5,
          backgroundColor: color,
        ),
        const SizedBox(width: 5),
        Text(label),
      ],
    );
  }
}
