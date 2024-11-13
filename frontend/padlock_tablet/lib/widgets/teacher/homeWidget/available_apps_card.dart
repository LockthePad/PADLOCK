import 'package:flutter/material.dart';
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
  List<custom_app_info.AppInfo> allowedApps = [];
  List<custom_app_info.AppInfo> allInstalledApps = [];
  Map<String, bool> appAllowedStatus = {};

  @override
  void initState() {
    super.initState();
    _fetchAllowedApps();
  }

  Future<void> _fetchAllowedApps() async {
    List<dynamic> fetchedApps = await AvailableAppsApi.fetchAllowedApps();

    setState(() {
      allowedApps = fetchedApps.map((app) {
        appAllowedStatus[app.packageName] = true; // 초기 상태 설정
        return custom_app_info.AppInfo(
          appId: app.appId,
          name: app.name,
          packageName: app.packageName,
          appImgUrl: app.appImgUrl,
        );
      }).toList();
    });
  }

  Future<void> _fetchInstalledAppsAndShowDialog() async {
    try {
      List<installed_app_info.AppInfo> apps =
          await InstalledApps.getInstalledApps();

      List<custom_app_info.AppInfo> tempApps = apps.map((app) {
        return custom_app_info.AppInfo(
          appId: null, // 초기화
          name: app.name,
          packageName: app.packageName,
          appImgUrl: null,
        );
      }).toList();

      List<custom_app_info.AppInfo> updatedApps =
          await AvailableAppsApi.postInstalledApps(tempApps);

      setState(() {
        allInstalledApps = updatedApps;
      });

      _showInstalledAppsDialog();
    } catch (e) {
      print('설치된 앱을 불러오거나 서버에 요청하는 중 오류 발생: $e');
    }
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
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: app.appImgUrl != null && app.appImgUrl!.isNotEmpty
            ? Image.network(app.appImgUrl!, fit: BoxFit.cover)
            : const Icon(
                Icons.apps,
                color: AppColors.white,
                size: 24,
              ),
      ),
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: _fetchInstalledAppsAndShowDialog,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.add,
          color: AppColors.grey,
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
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return SizedBox(
                width: 500,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allInstalledApps.length,
                  itemBuilder: (context, index) {
                    final app = allInstalledApps[index];
                    final isAllowed =
                        appAllowedStatus[app.packageName] ?? false;

                    return ListTile(
                      leading:
                          app.appImgUrl != null && app.appImgUrl!.isNotEmpty
                              ? Image.network(app.appImgUrl!, fit: BoxFit.cover)
                              : const Icon(Icons.apps),
                      title: Text(app.name),
                      subtitle: Text(app.packageName),
                      trailing: Switch(
                        value: isAllowed,
                        onChanged: (bool value) async {
                          final appId = app.appId ?? 0;
                          final previousState =
                              appAllowedStatus[app.packageName] ?? false;

                          // 다이얼로그와 전체 화면 상태 동시 업데이트
                          setDialogState(() {
                            appAllowedStatus[app.packageName] = value;
                            if (value) {
                              if (!allowedApps.any(
                                  (a) => a.packageName == app.packageName)) {
                                setState(() {
                                  allowedApps.add(app); // 전체 화면 상태 업데이트
                                });
                              }
                            } else {
                              setState(() {
                                allowedApps.removeWhere(
                                    (a) => a.packageName == app.packageName);
                              });
                            }
                          });

                          // API 요청 후 성공 시 상태 확정, 실패 시 롤백
                          final success =
                              await AvailableAppsApi.toggleAppStatus(
                                  appId, value);

                          if (!success) {
                            // API 실패 시 이전 상태로 롤백
                            setDialogState(() {
                              appAllowedStatus[app.packageName] = previousState;
                              if (previousState) {
                                setState(() {
                                  allowedApps.add(app);
                                });
                              } else {
                                setState(() {
                                  allowedApps.removeWhere(
                                      (a) => a.packageName == app.packageName);
                                });
                              }
                            });
                            print('앱 상태 변경 실패');
                          } else {
                            print('앱 상태 변경 성공');
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            },
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
