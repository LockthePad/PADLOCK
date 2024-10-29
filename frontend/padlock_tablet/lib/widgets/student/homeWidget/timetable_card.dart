import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/students/titmetable_item.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/common/card_container.dart';
import 'package:padlock_tablet/widgets/student/homeWidget/timetable_modal_widget.dart';

class TimetableCard extends StatelessWidget {
  final List<TimeTableItem> timeTable;
  final VoidCallback? onViewAll;

  TimetableCard({
    super.key,
    required this.timeTable,
    this.onViewAll,
  });

  //이건 테스트데이터 샘플
  final List<TimeTableData> sampleTimeTableData = [
    // 월요일
    TimeTableData(day: "월", period: "1", subject: "과학"),
    TimeTableData(day: "월", period: "2", subject: "과학"),
    TimeTableData(day: "월", period: "3", subject: "영어"),
    TimeTableData(day: "월", period: "4", subject: "음악"),
    TimeTableData(day: "월", period: "5", subject: "사회"),

    // 화요일
    TimeTableData(day: "화", period: "1", subject: "과학"),
    TimeTableData(day: "화", period: "2", subject: "국어"),
    TimeTableData(day: "화", period: "3", subject: "영어"),
    TimeTableData(day: "화", period: "4", subject: "체육"),
    TimeTableData(day: "화", period: "5", subject: "사회"),
    TimeTableData(day: "화", period: "6", subject: "미술"),

    // 수요일
    TimeTableData(day: "수", period: "1", subject: "과학"),
    TimeTableData(day: "수", period: "2", subject: "과학"),
    TimeTableData(day: "수", period: "3", subject: "체육"),
    TimeTableData(day: "수", period: "4", subject: "음악"),
    TimeTableData(day: "수", period: "5", subject: "과학"),
    TimeTableData(day: "수", period: "6", subject: "특활"),

    // 목요일
    TimeTableData(day: "목", period: "1", subject: "미술"),
    TimeTableData(day: "목", period: "2", subject: "미술"),
    TimeTableData(day: "목", period: "3", subject: "영어"),
    TimeTableData(day: "목", period: "4", subject: "사회"),
    TimeTableData(day: "목", period: "5", subject: "국어"),

    // 금요일
    TimeTableData(day: "금", period: "1", subject: "과학"),
    TimeTableData(day: "금", period: "2", subject: "과학"),
    TimeTableData(day: "금", period: "3", subject: "영어"),
    TimeTableData(day: "금", period: "4", subject: "국어"),
    TimeTableData(day: "금", period: "5", subject: "사회"),
  ];

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '오늘의 시간표',
            style: TextStyle(
              fontSize: 22,
              // fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: timeTable.length,
              itemBuilder: (context, index) {
                final item = timeTable[index];
                return _buildTimeTableItem(item);
              },
            ),
          ),
          if (onViewAll != null)
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
                      timeTableData: sampleTimeTableData,
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
