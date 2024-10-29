import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';

class AttendanceStatus extends StatelessWidget {
  final int presentCount;
  final int absentCount;
  final int lateCount;

  const AttendanceStatus({
    super.key,
    required this.presentCount,
    required this.absentCount,
    required this.lateCount,
  });

  @override
  Widget build(BuildContext context) {
    int total = presentCount + absentCount + lateCount;

    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.lilac,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 왼쪽: 출석현황 및 인원수
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '우리반 출석현황',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                _buildStatusCard('출석', presentCount, AppColors.successGreen),
                const SizedBox(height: 5),
                _buildStatusCard('자리비움', lateCount, AppColors.yellow),
                const SizedBox(height: 5),
                _buildStatusCard('결석', absentCount, AppColors.errorRed),
              ],
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            flex: 3,
            child: _buildAttendanceGraph(total),
          ),
        ],
      ),
    );
  }

  // 출석, 자리비움, 결석 카드 빌더
  Widget _buildStatusCard(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 70,
          padding: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$count명',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  // 원형 그래프 빌더
  Widget _buildAttendanceGraph(int total) {
    double presentPercentage = total > 0 ? (presentCount / total) * 100 : 0;
    double latePercentage = total > 0 ? (lateCount / total) * 100 : 0;
    double absentPercentage = total > 0 ? (absentCount / total) * 100 : 0;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: CircularProgressIndicator(
            value: 1.0, // 100%
            strokeWidth: 13,
            color: AppColors.errorRed,
            backgroundColor: AppColors.grey.withOpacity(0.3),
          ),
        ),
        SizedBox(
          width: 150,
          height: 150,
          child: CircularProgressIndicator(
            value: (presentPercentage + latePercentage) / 100,
            strokeWidth: 13,
            color: AppColors.yellow,
            backgroundColor: Colors.transparent,
          ),
        ),
        SizedBox(
          width: 150,
          height: 150,
          child: CircularProgressIndicator(
            value: presentPercentage / 100,
            strokeWidth: 13,
            color: AppColors.successGreen,
            backgroundColor: Colors.transparent,
          ),
        ),
        Text(
          '${presentPercentage.toStringAsFixed(0)}%',
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
      ],
    );
  }
}
