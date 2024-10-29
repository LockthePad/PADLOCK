import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/students/meal_info.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/common/card_container.dart';

class MealCard extends StatelessWidget {
  final MealInfo meal;
  final VoidCallback? onViewDetail;

  const MealCard({
    super.key,
    required this.meal,
    this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '오늘의 급식',
            style: TextStyle(
              fontSize: 22,
              // fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: meal.dishes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Center(
                    // Text를 Center 위젯으로 감싸기
                    child: Text(
                      meal.dishes[index],
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center, // 텍스트 자체도 가운데 정렬
                    ),
                  ),
                );
              },
            ),
          ),
          if (onViewDetail != null)
            Container(
              width: double.infinity,
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ElevatedButton(
                onPressed: onViewDetail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '전체보기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
