import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';

class CounselingListCard extends StatelessWidget {
  final String date;
  final String time;
  final String parentName;
  final VoidCallback onCancel; // 취소 버튼 콜백 추가

  const CounselingListCard({
    super.key,
    required this.date,
    required this.time,
    required this.parentName,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.circle,
                size: 10,
                color: AppColors.black,
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    '$time $parentName 학부모님',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: onCancel,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navy,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              '취소',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
