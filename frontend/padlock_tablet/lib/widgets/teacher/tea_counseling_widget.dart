import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/teacher/mainScreen/title_widget.dart';
import 'package:padlock_tablet/widgets/teacher/counselingWidget/counseling_calendar.dart';
import 'package:padlock_tablet/widgets/teacher/counselingWidget/counseling_list_card.dart';

class TeaCounselingWidget extends StatelessWidget {
  final List<Map<String, dynamic>> counselingRequests;

  const TeaCounselingWidget({
    super.key,
    required this.counselingRequests,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleWidget(title: '학부모상담 예약현황'),
          const SizedBox(height: 30),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 왼쪽: 캘린더와 텍스트
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '  2024년 10월',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      CounselingCalendar(
                        onDateSelected: (selectedDate) {
                          print('선택된 날짜: $selectedDate');
                        },
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(
                  width: 100,
                  thickness: 1,
                  color: AppColors.grey,
                ),
                // 오른쪽: 상담 신청 목록 (스크롤 가능)
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '상담신청 목록',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 0),
                      Expanded(
                        child: counselingRequests.isNotEmpty
                            ? Scrollbar(
                                thumbVisibility: true,
                                child: ListView.builder(
                                  itemCount: counselingRequests.length,
                                  itemBuilder: (context, index) {
                                    final request = counselingRequests[index];
                                    return CounselingListCard(
                                      date:
                                          request['date'] ?? '날짜 없음', // 기본 값 설정
                                      time:
                                          request['time'] ?? '시간 없음', // 기본 값 설정
                                      parentName: request['parentName'] ??
                                          '이름 없음', // 기본 값 설정
                                    );
                                  },
                                ),
                              )
                            : const Center(
                                child: Text(
                                  '예약된 상담이 없습니다.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
