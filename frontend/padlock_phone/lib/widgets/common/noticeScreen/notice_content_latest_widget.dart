import 'package:flutter/material.dart';
import 'package:padlock_phone/screens/common/notice_detail_screen.dart';

class NoticeContentLatestWidget extends StatelessWidget {
  const NoticeContentLatestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoticeDetailScreen(),
            ),
          );
        },
        child: const Text('최신 공지사항 위젯'),
      ),
    );
  }
}
