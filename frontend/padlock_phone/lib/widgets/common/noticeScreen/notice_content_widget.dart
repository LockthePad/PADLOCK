import 'package:flutter/material.dart';
import 'package:padlock_phone/screens/common/notice_detail_screen.dart';

class NoticeContentWidget extends StatelessWidget {
  const NoticeContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: const Text('단순공지사항 위젯'),
    );
  }
}
