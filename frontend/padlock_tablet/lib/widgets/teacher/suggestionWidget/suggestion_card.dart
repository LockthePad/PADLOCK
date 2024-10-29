import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';

class SuggestionCard extends StatelessWidget {
  final String content;
  final String timestamp;
  final String author;
  final bool isRead;

  const SuggestionCard({
    super.key,
    required this.content,
    required this.timestamp,
    required this.author,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: isRead ? AppColors.white : AppColors.lilac,
        border: Border.all(
          color: AppColors.lilac,
          width: isRead ? 1.5 : 0,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Text(
            timestamp,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            author,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
