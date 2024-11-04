import 'package:flutter/material.dart';
import 'package:padlock_phone/theme/colors.dart';

class NoticeDetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final String createdAt;

  const NoticeDetailScreen({
    super.key,
    required this.title,
    required this.content,
    required this.createdAt,
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 16, bottom: 16, right: 16, left: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                ),
                const SizedBox(height: 8),

                // 날짜
                Text(
                  _formatDate(createdAt),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey,
                      ),
                ),

                // 구분선
                const SizedBox(height: 24),
                const Divider(height: 1, color: AppColors.grey),
                const SizedBox(height: 32),

                // 내용
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
