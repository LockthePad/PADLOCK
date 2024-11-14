import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:padlock_tablet/api/teacher/notification_api.dart';
import 'package:padlock_tablet/theme/colors.dart';

class NotificationWriting extends StatefulWidget {
  final VoidCallback onSubmit;

  const NotificationWriting({
    super.key,
    required this.onSubmit,
  });

  @override
  State<NotificationWriting> createState() => _NotificationWritingState();
}

class _NotificationWritingState extends State<NotificationWriting> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> _submitNotification() async {
    try {
      final classroomIdString = await _storage.read(key: 'classroomId');
      if (classroomIdString == null) {
        return;
      }

      // 공지사항 작성 API 호출
      final noticeId = await NotificationApi.createNotification(
        _titleController.text,
        _contentController.text,
      );
      if (noticeId != null) {
        widget.onSubmit();
      }
    } catch (e) {
      print('공지사항 작성 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 30,
        right: 30,
        top: 30,
        bottom: MediaQuery.of(context).viewInsets.bottom + 30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 스크롤 가능하도록 수정
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: '  제목',
              alignLabelWithHint: true, // 라벨 위치 상단 고정
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              labelText: '  내용',
              alignLabelWithHint: true, // 라벨 위치 상단 고정
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
            ),
            maxLines: 10,
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _submitNotification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                ),
                child: const Text(
                  '공지하기',
                  style: TextStyle(fontSize: 15, color: AppColors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
