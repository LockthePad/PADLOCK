import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/api/teacher/notification_api.dart';

class NotificationEdit extends StatefulWidget {
  final String initialTitle;
  final String initialContent;
  final int noticeId;
  final VoidCallback onSubmit;

  const NotificationEdit({
    super.key,
    required this.initialTitle,
    required this.initialContent,
    required this.noticeId,
    required this.onSubmit,
  });

  @override
  _NotificationEditState createState() => _NotificationEditState();
}

class _NotificationEditState extends State<NotificationEdit> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);
  }

  Future<void> _updateNotification() async {
    try {
      await NotificationApi.updateNotification(
        widget.noticeId,
        _titleController.text,
        _contentController.text,
      );
      widget.onSubmit(); // 성공 시 콜백 함수 호출하여 화면을 전환
    } catch (e) {
      print("Failed to update notification: $e");
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: '제목',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _contentController,
            maxLines: 12,
            decoration: InputDecoration(
              labelText: '내용',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          SizedBox(height: 25),
          Center(
            child: ElevatedButton(
              onPressed: _updateNotification,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              ),
              child: Text(
                '수정하기',
                style: TextStyle(fontSize: 15, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
