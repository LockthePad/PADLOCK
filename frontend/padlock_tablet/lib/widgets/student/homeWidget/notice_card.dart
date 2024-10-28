import 'package:flutter/material.dart';
import 'package:padlock_tablet/widgets/common/card_container.dart';

class NoticeCard extends StatelessWidget {
  final VoidCallback? onTap;

  const NoticeCard({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Image.asset('assets/notice_icon.png', width: 24, height: 24),
              const SizedBox(width: 8),
              const Text(
                '공지사항',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
