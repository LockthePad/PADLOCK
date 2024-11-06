import 'package:flutter/material.dart';
import 'package:padlock_phone/apis/common/notice_api.dart';
import 'package:padlock_phone/screens/common/notice_detail_screen.dart';
import 'package:padlock_phone/theme/colors.dart';

class NoticeContentLatestWidget extends StatelessWidget {
  final Notice notice; // 개별 필드 대신 Notice 모델 사용

  const NoticeContentLatestWidget({
    super.key,
    required this.notice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 4),
              Text(
                '📌 최근 공지',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
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
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notice.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(notice.createdAt),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 0.5,
                      width: double.infinity,
                      color: AppColors.white,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notice.content,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final parts = dateString.split(' ');
    final dateParts = parts[0].split('.');

    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);

    return '${year}.${month.toString().padLeft(2, '0')}.${day.toString().padLeft(2, '0')}';
  }
}
