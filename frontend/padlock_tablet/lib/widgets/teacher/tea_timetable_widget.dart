import 'package:flutter/material.dart';
import 'package:padlock_tablet/api/teacher/timetable_api.dart';
import 'package:padlock_tablet/models/teacher/timetable_item.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/teacher/mainScreen/title_widget.dart';

class TeaTimetableWidget extends StatefulWidget {
  const TeaTimetableWidget({super.key});

  @override
  _TeaTimetableWidgetState createState() => _TeaTimetableWidgetState();
}

class _TeaTimetableWidgetState extends State<TeaTimetableWidget> {
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
  List<List<String?>> timetable =
      List.generate(6, (_) => List<String?>.filled(5, null));

  @override
  void initState() {
    super.initState();
    _loadTimetable();
  }

  Future<void> _loadTimetable() async {
    try {
      List<TimetableItem> fetchedTimetable =
          await TimetableApi.fetchTimetable();
      setState(() {
        for (var item in fetchedTimetable) {
          int dayIndex = ["MON", "TUE", "WED", "THU", "FRI"].indexOf(item.day);
          if (dayIndex != -1 && item.period > 0 && item.period <= 6) {
            timetable[item.period - 1][dayIndex] = item.subject;
          }
        }
      });
    } catch (e) {
      print("시간표 불러오기 실패: $e");
    }
  }

  Future<void> _showDeleteConfirmationDialog(
      int periodIndex, int dayIndex) async {
    final day = ["MON", "TUE", "WED", "THU", "FRI"][dayIndex];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // 모서리 둥글게 설정
          ),
          title: Text(
            " 삭제하시겠습니까?",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "취소",
                style: TextStyle(color: AppColors.navy),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () async {
                bool success = await TimetableApi.removeSubjectFromTimetable(
                  day: day,
                  period: periodIndex + 1,
                );
                if (success) {
                  setState(() {
                    timetable[periodIndex][dayIndex] = null;
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text(
                "확인",
                style: TextStyle(color: AppColors.navy),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleWidget(title: '우리반 시간표'),
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      return Draggable<String>(
                        data: subject,
                        feedback: _buildSubjectCard(subject, dragging: true),
                        childWhenDragging:
                            _buildSubjectCard(subject, opacity: 0.3),
                        child: _buildSubjectCard(subject),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                const VerticalDivider(width: 20, color: AppColors.grey),
                const SizedBox(width: 20),
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Row(
                        children: [
                          const SizedBox(width: 60),
                          ...["월요일", "화요일", "수요일", "목요일", "금요일"]
                              .map((day) => Expanded(
                                    child: Center(
                                      child: Text(day,
                                          style: const TextStyle(fontSize: 20)),
                                    ),
                                  )),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Column(
                          children: List.generate(6, (periodIndex) {
                            return Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    alignment: Alignment.center,
                                    child: Text("${periodIndex + 1}교시",
                                        style: const TextStyle(fontSize: 18)),
                                  ),
                                  ...List.generate(5, (dayIndex) {
                                    return Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (timetable[periodIndex]
                                                  [dayIndex] !=
                                              null) {
                                            _showDeleteConfirmationDialog(
                                                periodIndex, dayIndex);
                                          }
                                        },
                                        child: DragTarget<String>(
                                          onAccept: (subject) async {
                                            setState(() {
                                              timetable[periodIndex][dayIndex] =
                                                  subject;
                                            });
                                            await TimetableApi
                                                .addSubjectToTimetable(
                                              day: [
                                                "MON",
                                                "TUE",
                                                "WED",
                                                "THU",
                                                "FRI"
                                              ][dayIndex],
                                              period: periodIndex + 1,
                                              subject: subject,
                                            );
                                          },
                                          builder: (context, candidateData,
                                              rejectedData) {
                                            final subject =
                                                timetable[periodIndex]
                                                    [dayIndex];
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
                                                      color: AppColors.black),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
            child: Text(subject, style: const TextStyle(fontSize: 20)),
          ),
        ),
      ),
    );
  }
}
