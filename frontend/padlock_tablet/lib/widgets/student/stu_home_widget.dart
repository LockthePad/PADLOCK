import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/students/app_info.dart';
import 'package:padlock_tablet/models/students/class_info.dart';
import 'package:padlock_tablet/models/students/meal_info.dart';
import 'package:padlock_tablet/models/students/titmetable_item.dart';
import 'package:padlock_tablet/widgets/student/homeWidget/available_apps_card.dart';
import 'package:padlock_tablet/widgets/student/homeWidget/board_to_text_card.dart';
import 'package:padlock_tablet/widgets/student/homeWidget/current_class_banner.dart';
import 'package:padlock_tablet/widgets/student/homeWidget/meal_card.dart';
import 'package:padlock_tablet/widgets/student/homeWidget/notice_card.dart';
import 'package:padlock_tablet/widgets/student/homeWidget/timetable_card.dart';
import 'package:camera/camera.dart';

class StuHomeWidget extends StatelessWidget {
  final ClassInfo currentClass;
  final List<TimeTableItem> timeTable;
  final MealInfo meal;
  final List<AppInfo> availableApps;
  final Function(XFile) onPictureTaken;

  const StuHomeWidget({
    super.key,
    required this.currentClass,
    required this.timeTable,
    required this.meal,
    required this.availableApps,
    required this.onPictureTaken,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Column(
        children: [
          SizedBox(
            height: 230,
            child: CurrentClassBanner(classInfo: currentClass),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 왼쪽 열
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            // NoticeCard를 왼쪽 절반 공간에 배치
                            Expanded(
                              child: NoticeCard(
                                onTap: () {/* 처리 */},
                              ),
                            ),
                            // 카드 사이 간격
                            const SizedBox(width: 24),
                            // BoardToTextCard를 오른쪽 절반 공간에 배치
                            Expanded(
                              child: BoardToTextCard(
                                onPictureTaken: onPictureTaken,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 135,
                        child: AvailableAppsCard(apps: availableApps),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // 오른쪽 열
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TimetableCard(
                          timeTable: timeTable,
                          onViewAll: () {/* 처리 */},
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: MealCard(
                          meal: meal,
                          onViewDetail: () {/* 처리 */},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
