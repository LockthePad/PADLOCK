import 'package:flutter/material.dart';
import 'package:padlock_phone/theme/colors.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({
    super.key,
    required this.subtitle,
    required this.title,
    this.myicon,
  });

  final String subtitle;
  final String title;
  final String? myicon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.yellow, width: 2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (myicon != null) Image.asset('assets/images/$myicon.png'),
          Column(
            children: [
              Text(
                subtitle,
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
