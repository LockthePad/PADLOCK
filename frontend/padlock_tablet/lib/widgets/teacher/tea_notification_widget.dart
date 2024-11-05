import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/teacher/notice_item.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/teacher/mainScreen/title_widget.dart';
import 'package:padlock_tablet/widgets/teacher/notificationWidget/notification_detail.dart';
import 'package:padlock_tablet/widgets/teacher/notificationWidget/notification_editing.dart';
import 'package:padlock_tablet/widgets/teacher/notificationWidget/notification_writing.dart';
import 'package:padlock_tablet/api/teacher/notification_api.dart';

class TeaNotificationWidget extends StatefulWidget {
  const TeaNotificationWidget({super.key});

  @override
  State<TeaNotificationWidget> createState() => _TeaNotificationWidgetState();
}

class _TeaNotificationWidgetState extends State<TeaNotificationWidget> {
  List<NoticeItem> notices = [];
  int selectedIndex = -1;
  bool isWritingMode = true;
  bool isEditingMode = false;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final fetchedNotices =
          await NotificationApi.fetchNotifications(9); // classroomId 수정 가능
      setState(() {
        notices = fetchedNotices;
        if (notices.isNotEmpty) {
          selectedIndex = 0;
          isWritingMode = false;
          isEditingMode = false;
        } else {
          isWritingMode = true;
        }
      });
    } catch (e) {
      print('Failed to load notifications: $e');
    }
  }

  Future<void> deleteNotification(int noticeId) async {
    final success = await NotificationApi.deleteNotification(noticeId);
    if (success) {
      setState(() {
        notices.removeWhere((notice) => notice.noticeId == noticeId);
        if (notices.isEmpty) {
          isWritingMode = true;
        } else {
          selectedIndex = 0;
          isWritingMode = false;
          isEditingMode = false;
        }
      });
    } else {
      print('Failed to delete notification');
    }
  }

  void showDeleteConfirmationDialog(int noticeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white, // 배경색 설정
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // 모서리 둥글게 설정
          ),
          title: const Text(
            " 삭제하시겠습니까?",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          // content: const Text("삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // 모달 닫기
              child: const Text(
                "취소",
                style: TextStyle(color: AppColors.navy),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
                deleteNotification(noticeId); // 삭제 요청
              },
              child: const Text(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '   공지사항 목록',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isWritingMode = true;
                                isEditingMode = false;
                                selectedIndex = -1;
                              });
                            },
                            child: const Text(
                              '작성하기   ',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
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
                                        isEditingMode = false;
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
                                                .createdAt
                                                .toString()
                                                .substring(0, 10),
                                            style: const TextStyle(
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
                // 우측 상세 내용, 작성 페이지, 또는 수정 페이지
                Expanded(
                  flex: 3,
                  child: isWritingMode
                      ? NotificationWriting(onSubmit: () {
                          setState(() {
                            isWritingMode = false;
                            fetchNotifications();
                          });
                        })
                      : isEditingMode
                          ? NotificationEdit(
                              initialTitle: notices[selectedIndex].title,
                              initialContent: notices[selectedIndex].content,
                              noticeId: notices[selectedIndex].noticeId,
                              onSubmit: () {
                                setState(() {
                                  isEditingMode = false;
                                  fetchNotifications();
                                });
                              },
                            )
                          : selectedIndex != -1
                              ? NotificationDetail(
                                  title: notices[selectedIndex].title,
                                  content: notices[selectedIndex].content,
                                  date: notices[selectedIndex]
                                      .createdAt
                                      .toString()
                                      .substring(0, 10),
                                  onEdit: () {
                                    setState(() {
                                      isEditingMode = true;
                                    });
                                  },
                                  onDelete: () {
                                    showDeleteConfirmationDialog(
                                        notices[selectedIndex].noticeId);
                                  },
                                )
                              : const Center(
                                  child: Text(
                                    '공지사항이 없습니다.',
                                    style: TextStyle(fontSize: 18),
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
