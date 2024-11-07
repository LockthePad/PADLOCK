import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';

class NoteSavingCard extends StatefulWidget {
  final String content;
  final String timestamp;
  final bool isSelected;
  final VoidCallback onTap;

  const NoteSavingCard({
    super.key,
    required this.content,
    required this.timestamp,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<NoteSavingCard> createState() => _NoteSavingCardState();
}

class _NoteSavingCardState extends State<NoteSavingCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: widget.isSelected ? AppColors.paleYellow : AppColors.white,
          border: Border.all(
            color: AppColors.paleYellow,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.content,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Text(
              widget.timestamp,
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
