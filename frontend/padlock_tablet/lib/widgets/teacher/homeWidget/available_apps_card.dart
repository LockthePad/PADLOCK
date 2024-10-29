import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/teacher/app_info.dart';
import 'package:padlock_tablet/theme/colors.dart';

class AvailableAppsCard extends StatelessWidget {
  final List<AppInfo> apps;

  const AvailableAppsCard({
    super.key,
    required this.apps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 30, bottom: 20, left: 40, right: 20),
      decoration: BoxDecoration(
        color: AppColors.lilac,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '허용된 앱',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: apps.map((app) => _buildAppIcon(app)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppIcon(AppInfo app) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: app.backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          app.iconData,
          color: AppColors.white,
          size: 24,
        ),
      ),
    );
  }
}
