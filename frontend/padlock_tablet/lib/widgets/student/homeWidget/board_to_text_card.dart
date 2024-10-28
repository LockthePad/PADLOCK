import 'package:flutter/material.dart';
import 'package:padlock_tablet/widgets/common/card_container.dart';

class BoardToTextCard extends StatelessWidget {
  final VoidCallback? onTap;

  const BoardToTextCard({
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
              // Image.asset('assets/camera_icon.png', width: 24, height: 24),
              const SizedBox(width: 8),
              const Text(
                '필기 변환하기',
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
