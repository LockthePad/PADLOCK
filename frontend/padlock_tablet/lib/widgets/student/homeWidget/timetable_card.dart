import 'package:flutter/material.dart';
import 'package:padlock_tablet/api/student/timetable_api.dart';
import 'package:padlock_tablet/models/students/titmetable_item.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/common/card_container.dart';
import 'package:padlock_tablet/widgets/student/homeWidget/timetable_modal_widget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TimetableCard extends StatefulWidget {
  final List<TimeTableItem> timeTable;
  final VoidCallback? onViewAll;

  const TimetableCard({
    super.key,
    required this.timeTable,
    this.onViewAll,
  });

  @override
  State<TimetableCard> createState() => _TimetableCardState();
}

class _TimetableCardState extends State<TimetableCard> {
  List<TimeTableData> fullTimeTable = [];
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchFullTimeTable();
  }

  Future<void> _fetchFullTimeTable() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      String? classroomId = await storage.read(key: 'classroomId');

      if (accessToken != null && accessToken.isNotEmpty) {
        final schedules = await TimetableApi.fetchSchedules(
          token: accessToken,
          classroomId: classroomId!,
        );

        final convertedSchedules = schedules
            .map((schedule) => TimeTableData(
                  day: _convertDayToKorean(schedule['day']),
                  period: schedule['period'].toString(),
                  subject: schedule['subject'],
                ))
            .toList();

        setState(() {
          fullTimeTable = convertedSchedules;
        });
      }
    } catch (e) {
      print('Error loading full timetable: $e');
    }
  }

  String _convertDayToKorean(String englishDay) {
    switch (englishDay) {
      case 'MON':
        return '월';
      case 'TUE':
        return '화';
      case 'WED':
        return '수';
      case 'THU':
        return '목';
      case 'FRI':
        return '금';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8), // 상단 여백 줄임
            child: Text(
              '오늘의 시간표',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            height: 222,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.timeTable
                  .map((item) => _buildTimeTableItem(item))
                  .toList(),
            ),
          ),
          if (widget.onViewAll != null)
            Container(
              width: double.infinity,
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierColor: Colors.black.withOpacity(0.7),
                    builder: (context) => TimetableModalWidget(
                      timeTableData: fullTimeTable,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '전체보기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeTableItem(TimeTableItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppColors.paleYellow,
                  width: 1,
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.period,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 20),
                Text(
                  item.subject,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
