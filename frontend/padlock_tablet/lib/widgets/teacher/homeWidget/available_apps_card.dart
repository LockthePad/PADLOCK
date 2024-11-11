import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:padlock_tablet/api/teacher/available_apps_api.dart';
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
  List<custom_app_info.AppInfo> allowedApps = [];
  List<custom_app_info.AppInfo> allInstalledApps = [];

  // 각 앱의 허용 상태를 관리하는 맵
  Map<String, bool> appAllowedStatus = {};

  @override
  void initState() {
    super.initState();
    _fetchAllowedApps();
    _fetchInstalledApps();
  }

  Future<void> _fetchAllowedApps() async {
    List<dynamic> fetchedApps = await AvailableAppsApi.fetchAllowedApps();

    setState(() {
      allowedApps = fetchedApps.map((app) {
        return custom_app_info.AppInfo(
          name: app['appName'] ?? 'Unknown App',
          packageName: app['appPackage'] ?? 'unknown.package',
          iconData: Icons.apps,
        );
      }).toList();

      // 초기 허용 상태 설정
      for (var app in allowedApps) {
        appAllowedStatus[app.packageName] = true;
      }
    });
  }

  Future<void> _fetchInstalledApps() async {
    try {
      List<installed_app_info.AppInfo> apps =
          await InstalledApps.getInstalledApps();
      setState(() {
        allInstalledApps = apps.map((app) {
          return custom_app_info.AppInfo(
            name: app.name,
            packageName: app.packageName,
            iconData: Icons.apps,
          );
        }).toList();

        // 설치된 앱의 초기 허용 상태를 false로 설정
        for (var app in allInstalledApps) {
          if (!appAllowedStatus.containsKey(app.packageName)) {
            appAllowedStatus[app.packageName] = false;
          }
        }
      });
    } catch (e) {
      print('설치된 앱 불러오기 실패: $e');
    }
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
      print("아이콘 불러오기 실패: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 30, bottom: 20, left: 40, right: 20),
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
              ...allowedApps.map((app) => _buildAppIcon(app)),
              _buildAddButton(),
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
          return const CircularProgressIndicator();
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
              child: const Icon(
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
    return InkWell(
      onTap: () {
        _showInstalledAppsDialog();
      },
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

  void _showInstalledAppsDialog() {
    if (allInstalledApps.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: const Text('설치된 앱 목록'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: allInstalledApps.length,
              itemBuilder: (context, index) {
                final app = allInstalledApps[index];

                return StatefulBuilder(
                  builder: (context, setState) {
                    return ListTile(
                      leading: FutureBuilder<Image?>(
                        future: _getAppIcon(app.packageName),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!;
                          } else {
                            return const Icon(Icons.apps);
                          }
                        },
                      ),
                      title: Text(app.name),
                      subtitle: Text(app.packageName),
                      trailing: Switch(
                        value: appAllowedStatus[app.packageName] ?? false,
                        onChanged: (bool value) {
                          setState(() {
                            appAllowedStatus[app.packageName] = value;
                            if (value) {
                              allowedApps.add(app);
                            } else {
                              allowedApps.removeWhere((allowedApp) =>
                                  allowedApp.packageName == app.packageName);
                            }
                          });
                          this.setState(() {}); // 외부 상태 반영
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}
