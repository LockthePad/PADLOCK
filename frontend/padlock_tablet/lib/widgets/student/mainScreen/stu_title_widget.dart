import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';

class StuTitleWidget extends StatelessWidget {
  final String title;

  const StuTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
      decoration: BoxDecoration(
        color: AppColors.yellow,
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
