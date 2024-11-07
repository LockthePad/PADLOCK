import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/teacher/suggestionWidget/suggestion_detail_modal.dart';

class SuggestionCard extends StatelessWidget {
  final int suggestionId;
  final String content;
  final String timestamp;
  final String author;
  final bool isRead;
  final VoidCallback onReadUpdate; // onReadUpdate 추가

  const SuggestionCard({
    super.key,
    required this.suggestionId,
    required this.content,
    required this.timestamp,
    required this.author,
    required this.isRead,
    required this.onReadUpdate, // onReadUpdate 추가
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SuggestionDetailModal(
              suggestionId: suggestionId,
              content: content,
              timestamp: timestamp,
              author: author,
              onReadUpdate: onReadUpdate, // SuggestionDetailModal로 전달
            );
          },
        );
      },
      child: Container(
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
      ),
    );
  }
}
