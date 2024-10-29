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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const SizedBox(height: 8),
          Image.asset('assets/camera.png', width: 125, height: 125),
          const Text(
            '필기 변환하기',
            style: TextStyle(
              fontSize: 22,
              // fontWeight: FontWeight.bold,
            ),
          ),
          // const SizedBox(height: 40),
        ],
      ),
    );
  }
}
