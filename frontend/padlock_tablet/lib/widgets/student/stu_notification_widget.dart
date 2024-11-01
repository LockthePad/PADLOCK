import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/student/mainScreen/stu_title_widget.dart';

class Notice {
  final String title;
  final String content;
  final DateTime date;

  Notice({
    required this.title,
    required this.content,
    required this.date,
  });
}

class StuNotificationWidget extends StatefulWidget {
  const StuNotificationWidget({super.key});

  @override
  State<StuNotificationWidget> createState() => _StuNotificationWidgetState();
}

class _StuNotificationWidgetState extends State<StuNotificationWidget> {
  // 임시 데이터 - 나중에 API로 대체
  final List<Notice> notices = [
    Notice(
      title: "2025년 3,4학년 검..",
      content: "2025학년도 3,4학년 검정고시 관련 안내사항입니다...",
      date: DateTime(2024, 12, 27),
    ),
    Notice(
      title: "국군의 날(10월 1일)..",
      content: "국군의 날 임시공휴일 지정 관련 안내사항입니다...",
      date: DateTime(2024, 12, 27),
    ),
    Notice(
      title: "공지사항 제목 1",
      content: "공지사항 내용 1",
      date: DateTime(2024, 12, 27),
    ),
    Notice(
      title: "2025년 3,4학년 검..",
      content: "2025학년도 3,4학년 검정고시 관련 안내사항입니다...",
      date: DateTime(2024, 12, 27),
    ),
    Notice(
      title: "국군의 날(10월 1일)..",
      content: "국군의 날 임시공휴일 지정 관련 안내사항입니다...",
      date: DateTime(2024, 12, 27),
    ),
    Notice(
      title: "공지사항 제목 1",
      content: "공지사항 내용 1",
      date: DateTime(2024, 12, 27),
    ),
    Notice(
      title: "2025년 3,4학년 검..",
      content: "2025학년도 3,4학년 검정고시 관련 안내사항입니다...",
      date: DateTime(2024, 12, 27),
    ),
    Notice(
      title: "국군의 날(10월 1일)..",
      content: "국군의 날 임시공휴일 지정 관련 안내사항입니다...",
      date: DateTime(2024, 12, 27),
    ),
    Notice(
      title: "공지사항 제목 1",
      content: "공지사항 내용 1",
      date: DateTime(2024, 12, 27),
    ),
    Notice(
      title: "2025년 3,4학년 검..",
      content: "2025학년도 3,4학년 검정고시 관련 안내사항입니다...",
      date: DateTime(2024, 12, 27),
    ),
    Notice(
      title: "국군의 날(10월 1일)..",
      content: "국군의 날 임시공휴일 지정 관련 안내사항입니다...",
      date: DateTime(2024, 12, 27),
    ),
    Notice(
      title: "공지사항 제목 1",
      content: "공지사항 내용 1",
      date: DateTime(2024, 12, 27),
    ),
  ];

  int selectedIndex = 0; // 선택된 공지사항 인덱스

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          const StuTitleWidget(title: '공지사항'),
          const SizedBox(height: 15),
          Expanded(
            // 여기에 Expanded 추가
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 좌측 공지사항 목록
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // height 제거하고 SingleChildScrollView를 부모 크기에 맞추도록 함
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: List.generate(
                            notices.length,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: selectedIndex == index
                                        ? AppColors.paleYellow
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: AppColors.paleYellow,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notices[index].title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        notices[index]
                                            .date
                                            .toString()
                                            .substring(0, 10),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 1,
                  height: double.infinity,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(width: 8),
                // 우측 상세 내용
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notices[selectedIndex].title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notices[selectedIndex]
                              .date
                              .toString()
                              .substring(0, 10),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          notices[selectedIndex].content,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
