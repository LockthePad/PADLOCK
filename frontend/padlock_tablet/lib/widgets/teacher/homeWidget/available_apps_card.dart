import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:padlock_tablet/models/teacher/app_info.dart' as custom_app_info;
import 'package:padlock_tablet/theme/colors.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart' as installed_app_info;

class AvailableAppsCard extends StatefulWidget {
  final List<custom_app_info.AppInfo> apps;

  const AvailableAppsCard({
    super.key,
    required this.apps,
  });

  @override
  _AvailableAppsCardState createState() => _AvailableAppsCardState();
}

class _AvailableAppsCardState extends State<AvailableAppsCard> {
  static const platform = MethodChannel('com.example.padlock_tablet/app_icons');
  List<custom_app_info.AppInfo> allInstalledApps = [];

  @override
  void initState() {
    super.initState();
    _fetchInstalledApps();
  }

  Future<void> _fetchInstalledApps() async {
    List<installed_app_info.AppInfo> apps =
        await InstalledApps.getInstalledApps();
    setState(() {
      allInstalledApps = apps.map((app) {
        return custom_app_info.AppInfo(
          name: app.name,
          packageName: app.packageName,
          iconData: Icons.apps, // 기본 아이콘 설정
        );
      }).toList();
    });
  }

  Future<Image?> _getAppIcon(String packageName) async {
    try {
      final String? base64Icon = await platform.invokeMethod('getAppIcon', {
        'packageName': packageName,
      });

      if (base64Icon != null) {
        Uint8List bytes = base64Decode(base64Icon);
        return Image.memory(bytes);
      }
    } catch (e) {
      print("Failed to get app icon: $e");
    }
    return null;
  }

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
            children: [
              ...widget.apps.map((app) => _buildAppIcon(app)).toList(),
              _buildAddButton(), // 추가 버튼 추가
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppIcon(custom_app_info.AppInfo app) {
    return FutureBuilder<Image?>(
      future: _getAppIcon(app.packageName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: snapshot.data,
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.apps,
                color: AppColors.white,
                size: 24,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () => _showInstalledAppsModal(),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.add,
          color: AppColors.white,
          size: 24,
        ),
      ),
    );
  }

  void _showInstalledAppsModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '설치된 앱 목록',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: allInstalledApps.length,
                  itemBuilder: (context, index) {
                    final app = allInstalledApps[index];
                    return ListTile(
                      title: Text(app.name),
                      subtitle: Text(app.packageName), // 패키지 이름 표시
                      onTap: () {
                        // 앱을 선택하여 허용된 앱 목록에 추가
                        setState(() {
                          widget.apps.add(app);
                        });
                        Navigator.pop(context); // 모달 닫기
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
