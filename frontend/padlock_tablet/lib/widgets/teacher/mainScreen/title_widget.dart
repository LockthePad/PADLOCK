import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';

class TitleWidget extends StatelessWidget {
  final String title;

  const TitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
