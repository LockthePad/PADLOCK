import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CounselingCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected; // 날짜 선택 시 호출되는 콜백 함수
  final double buttonRadius; // 버튼의 radius 설정

  const CounselingCalendar({
    super.key,
    required this.onDateSelected,
    this.buttonRadius = 10.0, // 기본값 설정
  });

  @override
  _CounselingCalendarState createState() => _CounselingCalendarState();
}

class _CounselingCalendarState extends State<CounselingCalendar> {
  DateTime _focusedDay = DateTime.now(); // 현재 달
  DateTime? _selectedDay; // 선택된 날짜
  List<Map<String, dynamic>> _availableTimes = []; // 선택된 날짜의 시간 목록

  // 상담 가능한 기본 시간 데이터 (임시로 사용, 나중에 API 데이터로 대체)
  final List<Map<String, dynamic>> _defaultTimeSlots = [
    {'time': '16:00', 'status': 'available'},
    {'time': '16:30', 'status': 'unavailable'},
    {'time': '17:00', 'status': 'reserved'},
    {'time': '17:30', 'status': 'unavailable'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
      children: [
        // 캘린더 위젯
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
                _availableTimes = List.from(_defaultTimeSlots); // 시간 목록 업데이트
              });
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

        // 시간 선택 영역
        if (_selectedDay != null) ...[
          const Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Text(
                '상담 가능한 시간',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '을 설정해주세요!',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildTimeSlotButtons(),
          const SizedBox(height: 30),

          // 범례 영역
          Row(
            mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
            children: [
              SizedBox(
                width: 10,
              ),
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
      alignment: WrapAlignment.start, // 왼쪽 정렬
      spacing: 10,
      children: _availableTimes.map((timeSlot) {
        // 상태별 색상 처리
        Color backgroundColor;
        switch (timeSlot['status']) {
          case 'available':
            backgroundColor = AppColors.white;
            break;
          case 'reserved':
            backgroundColor = AppColors.lilac;
            break;
          default:
            backgroundColor = AppColors.grey;
        }

        return GestureDetector(
          onTap: () {
            if (timeSlot['status'] == 'unavailable') {
              setState(() {
                timeSlot['status'] = 'available';
              });
            } else if (timeSlot['status'] == 'available') {
              setState(() {
                timeSlot['status'] = 'unavailable';
              });
            }
          },
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
              timeSlot['time'],
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
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
