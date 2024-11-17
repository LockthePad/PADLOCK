import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:padlock_phone/apis/common/notice_api.dart';
import 'package:padlock_phone/theme/colors.dart';
import 'package:padlock_phone/widgets/common/noticeScreen/notice_content_latest_widget.dart';
import 'package:padlock_phone/widgets/common/noticeScreen/notice_content_widget.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  final storage = const FlutterSecureStorage();
  List<Notice> notices = [];
  bool isLoading = true;

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
      String? classroomId = await storage.read(key: 'selectedClassroomId');
      print('---------classroomID :$classroomId');

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('공지사항'),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.yellow),
                ),
              )
            : notices.isEmpty
                ? const Center(
                    child: Text('등록된 공지사항이 없습니다.'),
                  )
                : Column(
                    children: [
                      NoticeContentLatestWidget(
                        notice: notices[0], // Notice 객체 전체를 전달
                      ),
                      NoticeContentWidget(
                        notices: notices.skip(1).toList(),
                      ),
                    ],
                  ),
      ),
    );
  }
}
