import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/teacher/mainScreen/title_widget.dart';
import 'package:padlock_tablet/widgets/teacher/notificationWidget/notification_detail.dart';
import 'package:padlock_tablet/widgets/teacher/notificationWidget/notification_writing.dart';

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

class TeaNotificationWidget extends StatefulWidget {
  const TeaNotificationWidget({super.key});

  @override
  State<TeaNotificationWidget> createState() => _TeaNotificationWidgetState();
}

class _TeaNotificationWidgetState extends State<TeaNotificationWidget> {
  final List<Notice> notices = [
    Notice(
      title: "2025년 3,4학년 검..",
      content: "2025학년도 3,4학년 검정고시 관련 안내사항입니다...",
      date: DateTime(2024, 12, 27),
    ),
    Notice(
      title: "2025년 3,4학년 검..",
      content: "2025학년도 3,4학년 검정고시 관련 안내사항입니다...",
      date: DateTime(2024, 12, 27),
    ),
    Notice(
      title: "2025년 3,4학년 검..",
      content: "2025학년도 3,4학년 검정고시 관련 안내사항입니다...",
      date: DateTime(2024, 12, 27),
    ),
    Notice(
      title: "2025년 3,4학년 검..",
      content: "2025학년도 3,4학년 검정고시 관련 안내사항입니다...",
      date: DateTime(2024, 12, 27),
    ),
    Notice(
      title: "2025년 3,4학년 검..",
      content: "2025학년도 3,4학년 검정고시 관련 안내사항입니다...",
      date: DateTime(2024, 12, 27),
    ),
    // 추가 데이터...
  ];

  int selectedIndex = 0;
  bool isWritingMode = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, bottom: 30),
      child: Column(
        children: [
          const TitleWidget(title: '공지사항'),
          const SizedBox(height: 15),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 좌측 공지사항 목록 및 공지 작성 버튼
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  isWritingMode = true;
                                });
                              },
                              child: const Text(
                                '작성하기   ',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.black,
                                ),
                              )),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              children: List.generate(
                                notices.length,
                                (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                        isWritingMode = false;
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(25),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: selectedIndex == index
                                            ? AppColors.lilac
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: AppColors.lilac,
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
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            notices[index]
                                                .date
                                                .toString()
                                                .substring(0, 10),
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: AppColors.darkGrey,
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
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  width: 1,
                  height: double.infinity,
                  color: AppColors.grey,
                ),
                const SizedBox(width: 8),
                // 우측 상세 내용 또는 작성 페이지
                Expanded(
                  flex: 3,
                  child: isWritingMode
                      ? NotificationWriting(onSubmit: () {
                          setState(() {
                            isWritingMode = false;
                          });
                        })
                      : NotificationDetail(
                          title: notices[selectedIndex].title,
                          content: notices[selectedIndex].content,
                          date: notices[selectedIndex]
                              .date
                              .toString()
                              .substring(0, 10),
                          onEdit: () {
                            setState(() {
                              isWritingMode = true;
                            });
                          },
                          onDelete: () {
                            // 삭제 기능 로직 추가
                          },
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
