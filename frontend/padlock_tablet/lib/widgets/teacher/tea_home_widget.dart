import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/teacher/app_info.dart';
import 'package:padlock_tablet/models/teacher/class_info.dart';
import 'package:padlock_tablet/widgets/teacher/homeWidget/attendance_status.dart';
import 'package:padlock_tablet/widgets/teacher/homeWidget/available_apps_card.dart';
import 'package:padlock_tablet/widgets/teacher/homeWidget/consultation_status.dart';
import 'package:padlock_tablet/widgets/teacher/homeWidget/current_class_banner.dart';

class TeaHomeWidget extends StatelessWidget {
  final ClassInfo currentClass;
  final List<AppInfo> availableApps;

  const TeaHomeWidget({
    super.key,
    required this.currentClass,
    required this.availableApps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, bottom: 30),
      child: Column(
        children: [
          SizedBox(
            height: 240,
            child: CurrentClassBanner(classInfo: currentClass),
          ),
          const SizedBox(height: 10),
          const Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AttendanceStatus(),
                ),
                // 카드 사이 간격
                SizedBox(width: 10),
                // BoardToTextCard를 오른쪽 절반 공간에 배치
                Expanded(
                  child: ConsultationStatus(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 150,
            child: AvailableAppsCard(apps: availableApps),
          ),
        ],
      ),
    );
  }
}
