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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const SizedBox(height: 8),
          Image.asset('assets/notification.png', width: 130, height: 130),
          const Text(
            '공지사항',
            style: TextStyle(
              fontSize: 20,
              // fontWeight: FontWeight.bold,
            ),
          ),
          // const SizedBox(height: 40),
        ],
      ),
    );
  }
}
