import 'package:flutter/material.dart';
import 'package:padlock_tablet/api/common/current_period_api.dart';
import 'package:padlock_tablet/theme/colors.dart';

class CurrentClassBanner extends StatelessWidget {
  final CurrentPeriodInfo classInfo;

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
        color: classInfo.backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classInfo.date,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
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
                            fontWeight: FontWeight.w500,
                            height: 1.1,
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
                            fontWeight: FontWeight.w500,
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
          Positioned(
            right: 0,
            top: -20,
            bottom: -20,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset(
                'assets/stuMainIcon.png',
                width: 400,
                height: 400,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
