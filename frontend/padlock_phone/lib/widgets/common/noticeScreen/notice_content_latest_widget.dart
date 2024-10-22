import 'package:flutter/material.dart';

class NoticeContentLatestWidget extends StatelessWidget {
  const NoticeContentLatestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: const Text('최신공지사항 위젯'),
    );
  }
}
