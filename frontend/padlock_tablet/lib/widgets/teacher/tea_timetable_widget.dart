import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/teacher/mainScreen/title_widget.dart';

class TeaTimetableWidget extends StatefulWidget {
  const TeaTimetableWidget({super.key});

  @override
  _TeaTimetableWidgetState createState() => _TeaTimetableWidgetState();
}

class _TeaTimetableWidgetState extends State<TeaTimetableWidget> {
  // 과목 목록
  final List<String> subjects = [
    "국어",
    "수학",
    "사회",
    "과학",
    "영어",
    "음악",
    "미술",
    "체육"
  ];

  // 시간표 데이터 (가로: 요일, 세로: 교시)
  List<List<String?>> timetable =
      List.generate(6, (_) => List<String?>.filled(5, null));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 30,
        bottom: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 타이틀 위젯
          const TitleWidget(title: '우리반 시간표'),
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 20),

                // 왼쪽 과목 카드 리스트
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      return Draggable<String>(
                        data: subject,
                        feedback: _buildSubjectCard(subject, dragging: true),
                        childWhenDragging: _buildSubjectCard(subject,
                            dragging: false, opacity: 0.3),
                        child: _buildSubjectCard(subject),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 20),
                const VerticalDivider(
                  width: 20,
                  color: AppColors.grey,
                ),
                const SizedBox(
                  width: 20,
                ),
                // 오른쪽 시간표 표
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      // 요일 헤더
                      Row(
                        children: [
                          const SizedBox(width: 60), // 교시 열 간격 맞추기
                          ...["월요일", "화요일", "수요일", "목요일", "금요일"]
                              .map((day) => Expanded(
                                    child: Center(
                                      child: Text(day,
                                          style: const TextStyle(
                                            color: AppColors.black,
                                            fontSize: 20,
                                          )),
                                    ),
                                  ))
                              .toList(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // 시간표 그리드
                      Expanded(
                        child: Column(
                          children: List.generate(6, (periodIndex) {
                            return Expanded(
                              child: Row(
                                children: [
                                  // 교시 열
                                  Container(
                                    width: 60,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${periodIndex + 1}교시",
                                      style: const TextStyle(
                                        color: AppColors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  // 과목 배치 가능한 셀
                                  ...List.generate(5, (dayIndex) {
                                    return Expanded(
                                      child: DragTarget<String>(
                                        onAccept: (subject) {
                                          setState(() {
                                            timetable[periodIndex][dayIndex] =
                                                subject;
                                          });
                                        },
                                        builder: (context, candidateData,
                                            rejectedData) {
                                          final subject =
                                              timetable[periodIndex][dayIndex];
                                          return Container(
                                            margin: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: candidateData.isNotEmpty
                                                  ? AppColors.lilac
                                                  : AppColors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                subject ?? '',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: AppColors.black,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 과목 카드 빌더
  Widget _buildSubjectCard(String subject,
      {bool dragging = false, double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Card(
        color: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: AppColors.navy),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Center(
            // 텍스트 중앙 정렬
            child: Text(
              subject,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
