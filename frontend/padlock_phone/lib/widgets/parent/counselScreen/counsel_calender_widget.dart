import 'package:flutter/material.dart';
import 'package:padlock_phone/apis/parent/counsel_api.dart';
import 'package:padlock_phone/theme/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CounselCalenderWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final double buttonRadius;

  const CounselCalenderWidget({
    super.key,
    required this.onDateSelected,
    this.buttonRadius = 10.0,
  });

  @override
  _CounselCalenderWidgetState createState() => _CounselCalenderWidgetState();
}

class _CounselCalenderWidgetState extends State<CounselCalenderWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _availableTimes = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    String formattedDate =
        "${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')}";
    print("Initializing with today's date: $formattedDate");
    _fetchAvailableTimes(formattedDate);
  }

  Future<void> _fetchAvailableTimes(String selectedDate) async {
    try {
      print("Fetching available times for $selectedDate"); // 로그 추가
      final data = await CounselApi.fetchCounselingData(selectedDate);
      print("Fetched data: $data"); // 데이터 출력
      setState(() {
        _availableTimes = data ?? []; // 데이터가 null인 경우 빈 리스트로 처리
      });
    } catch (e) {
      print('상담가능 시간 불러오기 실패: $e'); // 오류 출력
      setState(() {
        _availableTimes = []; // 오류 발생 시 빈 리스트로 처리
      });
    }
  }

  // 상담 예약 요청 함수
  Future<void> _requestCounseling(int counselAvailableTimeId) async {
    try {
      bool success = await CounselApi.requestCounseling(counselAvailableTimeId);
      if (success) {
        print('상담 예약 성공');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('상담 예약이 성공적으로 완료되었습니다!')),
        );

        if (_selectedDay != null) {
          String formattedDate =
              "${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')}";
          await _fetchAvailableTimes(formattedDate); // 새로고침
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('상담 예약에 실패했습니다. 다시 시도해주세요.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('  2024년 11월',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
        SizedBox(
          height: 10,
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
            if (selectedDay
                .isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              String formattedDate =
                  "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";
              _fetchAvailableTimes(formattedDate);
              widget.onDateSelected(selectedDay);
            }
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
              Text(
                '  상담 가능한 시간',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildTimeSlotButtons(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              _buildLegendItem('예약가능', AppColors.yellow),
              const SizedBox(width: 10),
              _buildLegendItem('예약불가', AppColors.grey),
            ],
          ),
        ],
      ],
    );
  }

  // 시간 슬롯 버튼 빌드 함수
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
          case 1: // 상담불가
            backgroundColor = AppColors.grey;
            textColor = Colors.black;
            isClickable = false;
            break;
          case 2: // 상담가능
            backgroundColor = AppColors.yellow;
            textColor = Colors.white;
            isClickable = true;
            break;
          case 3: // 이미 예약됨
            backgroundColor = AppColors.grey;
            textColor = Colors.black;
            isClickable = false;
            break;
          default:
            backgroundColor = AppColors.grey;
            textColor = Colors.black;
        }

        return GestureDetector(
          onTap: isClickable
              ? () => _showConfirmationDialog(
                    timeSlot['id'], // 상담 가능한 시간 ID
                    time, // 시간 텍스트
                  )
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors.yellow,
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

  void _showConfirmationDialog(int counselAvailableTimeId, String time) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '예약 확인',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${_selectedDay!.year}년 ${_selectedDay!.month}월 ${_selectedDay!.day}일 $time\n예약하시겠습니까?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); // 모달 닫기
                        await _requestCounseling(counselAvailableTimeId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow, // 버튼 색상
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        '확인',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 범례 생성 함수
  Widget _buildLegendItem(
    String label,
    Color color,
  ) {
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
