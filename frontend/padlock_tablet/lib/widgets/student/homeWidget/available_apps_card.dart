import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/students/app_info.dart';
import 'package:padlock_tablet/widgets/common/card_container.dart';

class AvailableAppsCard extends StatelessWidget {
  final List<AppInfo> apps;

  const AvailableAppsCard({
    super.key,
    required this.apps,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '사용 가능한 앱',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: apps.map((app) => _buildAppIcon(app)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppIcon(AppInfo app) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: app.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          app.iconData,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
