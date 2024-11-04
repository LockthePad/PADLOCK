import 'package:flutter/material.dart';
import 'package:padlock_tablet/api/teacher/counseling_api.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/teacher/mainScreen/title_widget.dart';
import 'package:padlock_tablet/widgets/teacher/counselingWidget/counseling_calendar.dart';
import 'package:padlock_tablet/widgets/teacher/counselingWidget/counseling_list_card.dart';

class TeaCounselingWidget extends StatefulWidget {
  const TeaCounselingWidget({super.key});

  @override
  State<TeaCounselingWidget> createState() => _TeaCounselingWidgetState();
}

class _TeaCounselingWidgetState extends State<TeaCounselingWidget> {
  List<Map<String, dynamic>> counselingRequests = [];

  Future<void> fetchCounselingRequests() async {
    try {
      final data = await CounselingApi.fetchCounselingRequests();
      setState(() {
        counselingRequests = data;
      });
    } catch (e) {
      print('Failed to load counseling requests: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCounselingRequests();
  }

  Future<void> _cancelRequest(int parentId, int counselAvailableTimeId) async {
    final success = await CounselingApi.cancelCounselingRequest(
        parentId, counselAvailableTimeId);
    if (success) {
      setState(() {
        counselingRequests.removeWhere((request) =>
            request['parentId'] == parentId &&
            request['counselAvailableTimeId'] == counselAvailableTimeId);
      });
    } else {
      print('Failed to cancel the counseling request');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(right: 30, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleWidget(title: '학부모상담 예약현황'),
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '  2024년 11월',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      CounselingCalendar(
                        onDateSelected: (selectedDate) {},
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(
                  width: 100,
                  thickness: 1,
                  color: AppColors.grey,
                ),
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
                      const SizedBox(height: 10),
                      counselingRequests.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: counselingRequests.length,
                              itemBuilder: (context, index) {
                                final request = counselingRequests[index];
                                return CounselingListCard(
                                  date: request['counselAvailableDate'] ??
                                      '날짜 없음',
                                  time: request['counselAvailableTime']
                                          ?.substring(0, 5) ??
                                      '시간 없음',
                                  parentName: request['studentName'] ?? '이름 없음',
                                  onCancel: () => _cancelRequest(
                                    request['parentId'],
                                    request['counselAvailableTimeId'],
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 20),
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
                const SizedBox(width: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
