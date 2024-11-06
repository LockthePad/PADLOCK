import 'package:flutter/material.dart';
import 'package:padlock_phone/apis/common/notice_api.dart';
import 'package:padlock_phone/screens/common/notice_detail_screen.dart';
import 'package:padlock_phone/theme/colors.dart';

class NoticeContentWidget extends StatelessWidget {
  final List<Notice> notices; // NoticeItem 대신 Notice 모델 사용

  const NoticeContentWidget({
    super.key,
    required this.notices,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          // 공지목록 헤더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const SizedBox(width: 4),
                Text(
                  '📋 공지 목록',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 공지사항 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: notices.length,
              itemBuilder: (context, index) {
                return NoticeItemWidget(notice: notices[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NoticeItemWidget extends StatelessWidget {
  final Notice notice; // NoticeItem 대신 Notice 모델 사용

  const NoticeItemWidget({
    super.key,
    required this.notice,
  });

  String _formatDate(String dateString) {
    final parts = dateString.split(' ');
    final dateParts = parts[0].split('.');

    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);

    return '${year}.${month.toString().padLeft(2, '0')}.${day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.yellow,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoticeDetailScreen(
                  title: notice.title,
                  content: notice.content,
                  createdAt: notice.createdAt,
                ),
              ),
            );
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 16, bottom: 16, right: 16, left: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notice.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDate(notice.createdAt),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
