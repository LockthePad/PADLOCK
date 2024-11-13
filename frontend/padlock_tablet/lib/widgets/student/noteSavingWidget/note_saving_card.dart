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
        height: 160, // 컨테이너의 고정 높이 설정
        decoration: BoxDecoration(
          color: widget.isSelected ? AppColors.paleYellow : AppColors.white,
          border: Border.all(
            color: AppColors.paleYellow,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // 위젯들 사이의 공간을 균등하게 분배
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // content를 Expanded로 감싸서 남은 공간을 모두 사용하도록 함
              child: Text(
                widget.content,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              // timestamp는 항상 하단에 위치하게 됨
              widget.timestamp,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
