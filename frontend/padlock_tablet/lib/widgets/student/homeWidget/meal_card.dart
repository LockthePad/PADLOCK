import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/students/meal_info.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '오늘의 급식',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: meal.dishes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    meal.dishes[index],
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              },
            ),
          ),
          if (onViewDetail != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onViewDetail,
                child: const Text('자세히보기'),
              ),
            ),
        ],
      ),
    );
  }
}
