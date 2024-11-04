import 'package:flutter/material.dart';
import 'package:padlock_phone/theme/colors.dart';
import 'package:padlock_phone/widgets/common/noticeScreen/notice_content_latest_widget.dart';
import 'package:padlock_phone/widgets/common/noticeScreen/notice_content_widget.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 임시데이터
    final noticesData = [
      {
        "noticeId": 3,
        "title": "공지사항3",
        "content": "내용3",
        "createdAt": "2024.10.29 17:35"
      },
      {
        "noticeId": 2,
        "title": "공지사항2",
        "content": "내용2",
        "createdAt": "2024.10.29 17:34"
      },
      {
        "noticeId": 1,
        "title": "공지사항1",
        "content": "내용1",
        "createdAt": "2024.10.29 17:34"
      },
    ];

    // 최신 공지사항은 첫 번째 항목
    final latestNotice = noticesData[0];

    // 나머지 공지사항들은 리스트로 변환
    final notices =
        noticesData.skip(1).map((data) => NoticeItem.fromJson(data)).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('공지사항'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            NoticeContentLatestWidget(
              title: latestNotice['title'] as String,
              content: latestNotice['content'] as String,
              createdAt: latestNotice['createdAt'] as String,
            ),
            NoticeContentWidget(notices: notices),
          ],
        ),
      ),
    );
  }
}
