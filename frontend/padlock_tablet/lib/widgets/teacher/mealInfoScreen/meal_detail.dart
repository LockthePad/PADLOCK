import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/teacher/meal_model.dart';
import 'package:padlock_tablet/theme/colors.dart';

class MealDetailWidget extends StatelessWidget {
  final MealModel? mealData;

  const MealDetailWidget({
    super.key,
    required this.mealData,
  });

  @override
  Widget build(BuildContext context) {
    if (mealData == null) {
      return const Center(child: Text('급식 정보가 없습니다.'));
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${mealData!.date.substring(4, 6)}월 ${mealData!.date.substring(6, 8)}일 식단표입니다!',
            style: const TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors.lilac,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Image.asset(
                    'assets/chef.png',
                    width: 180,
                    height: 180,
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    // 메뉴 아이템이 길 경우를 대비해 Expanded 추가
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: mealData!.menu
                          .map((item) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  item,
                                  style: const TextStyle(height: 1.5),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.lilac,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '알러지 주의사항',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mealData!.allergyFood.isEmpty
                        ? '알러지 유발 식품이 없습니다.'
                        : mealData!.allergyFood.join(', '),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mealData!.calories,
                    style: TextStyle(
                      color: AppColors.darkGrey,
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
