import 'package:flutter/material.dart';
import 'package:padlock_phone/widgets/common/noticeScreen/notice_content_latest_widget.dart';
import 'package:padlock_phone/widgets/common/noticeScreen/notice_content_widget.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            NoticeContentLatestWidget(),
            NoticeContentWidget(),
          ],
        ),
      ),
    );
  }
}
