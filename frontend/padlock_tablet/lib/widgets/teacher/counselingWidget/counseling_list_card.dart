import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';

class CounselingListCard extends StatelessWidget {
  final String date;
  final String time;
  final String parentName;

  const CounselingListCard({
    super.key,
    required this.date,
    required this.time,
    required this.parentName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 불릿과 텍스트를 나란히 배치
          Row(
            children: [
              // 검은색 동그라미 불릿
              const Icon(
                Icons.circle,
                size: 10,
                color: AppColors.black,
              ),
              const SizedBox(width: 15),
              // 날짜, 시간, 학부모님 텍스트
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$date',
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
          // 취소 버튼
          ElevatedButton(
            onPressed: () {
              // TODO: 취소 버튼 로직 추가
            },
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
