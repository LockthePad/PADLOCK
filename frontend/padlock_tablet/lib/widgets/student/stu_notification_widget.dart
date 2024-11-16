import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:padlock_tablet/api/student/notice_api.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/student/mainScreen/stu_title_widget.dart';

class StuNotificationWidget extends StatefulWidget {
  const StuNotificationWidget({super.key});

  @override
  State<StuNotificationWidget> createState() => _StuNotificationWidgetState();
}

class _StuNotificationWidgetState extends State<StuNotificationWidget> {
  final storage = const FlutterSecureStorage();
  List<Notice> notices = [];
  bool isLoading = true;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  Future<void> _loadNotices() async {
    setState(() {
      isLoading = true;
    });

    try {
      String? token = await storage.read(key: 'accessToken');
      String? classroomId = await storage.read(key: 'classroomId');

      if (token == null || classroomId == null) {
        throw Exception('인증 정보가 없습니다.');
      }

      final fetchedNotices = await NoticeApi.fetchNotices(
        token: token,
        classroomId: classroomId,
      );

      setState(() {
        notices = fetchedNotices;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading notices: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('공지사항을 불러오는데 실패했습니다.')),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StuTitleWidget(title: '공지사항'),
          const SizedBox(height: 15),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.yellow),
                    ),
                  )
                : notices.isEmpty
                    ? const Center(
                        child: Text('등록된 공지사항이 없습니다.'),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 좌측 공지사항 목록
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    children: List.generate(
                                      notices.length,
                                      (index) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 7),
                                        child: InkWell(
                                          splashColor: Colors
                                              .transparent, // 터치 시 퍼지는 효과 제거
                                          highlightColor: Colors
                                              .transparent, // 터치 시 색상 변경 효과 제거
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;
                                            });
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(23),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
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
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  notices[index]
                                                      .createdAt
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
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: notices.isEmpty
                                  ? const Center(
                                      child: Text('공지사항을 선택해주세요.'),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              .createdAt
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
