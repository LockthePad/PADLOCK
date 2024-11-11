import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/teacher/class_info.dart';
import 'package:padlock_tablet/theme/colors.dart';

class CurrentClassBanner extends StatelessWidget {
  final ClassInfo classInfo;

  const CurrentClassBanner({
    super.key,
    required this.classInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classInfo.date,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Text(
                          '지금은 ',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 28,
                            height: 1.1, // 줄 높이 조정
                          ),
                        ),
                        Text(
                          classInfo.period,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          ' ${classInfo.subject}',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                        const Text(
                          ' 입니다.',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 28,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
