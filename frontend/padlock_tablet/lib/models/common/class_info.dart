import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/common/current_period_response.dart';
import 'package:padlock_tablet/theme/colors.dart';

class CurrentClassInfo {
  final String date;
  final String period;
  final String subject;
  final Color backgroundColor;

  CurrentClassInfo({
    required this.date,
    required this.period,
    required this.subject,
    required this.backgroundColor,
  });

  factory CurrentClassInfo.fromPeriodResponse(CurrentPeriodResponse response) {
    final now = DateTime.now();
    final date = '${now.year}년 ${now.month}월 ${now.day}일';

    if (response.isInClass) {
      return CurrentClassInfo(
        date: date,
        period: '${response.period}교시',
        subject: response.subject ?? '',
        backgroundColor: AppColors.yellow,
      );
    } else if (response.isBreakTime) {
      return CurrentClassInfo(
        date: date,
        period: '쉬는',
        subject: '시간',
        backgroundColor: AppColors.yellow,
      );
    } else if (response.isOutOfClassTime) {
      return CurrentClassInfo(
        date: date,
        period: '수업 시간',
        subject: '외',
        backgroundColor: AppColors.yellow,
      );
    } else {
      return CurrentClassInfo(
        date: date,
        period: '수업',
        subject: '없음',
        backgroundColor: AppColors.yellow,
      );
    }
  }
}
