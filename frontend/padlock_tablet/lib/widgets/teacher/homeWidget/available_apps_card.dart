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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAllowedApps();
  }

  Future<void> _fetchAllowedApps() async {
    List<dynamic> fetchedApps = await AvailableAppsApi.fetchAllowedApps();

    setState(() {
      allowedApps = fetchedApps.map((app) {
        appAllowedStatus[app.packageName] = true;
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
    setState(() {
      isLoading = true;
    });

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            if (isLoading) {
              _fetchInstalledApps(setDialogState);
            }
            return AlertDialog(
              backgroundColor: AppColors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('설치된 앱 목록', style: TextStyle(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              content: SizedBox(
                width: 500,
                height: 400,
                child: Stack(
                  children: [
                    if (isLoading)
                      const Center(child: CircularProgressIndicator()),
                    if (!isLoading)
                      ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8), // 리스트 간 간격 설정
                        itemCount: allInstalledApps.length,
                        itemBuilder: (context, index) {
                          final app = allInstalledApps[index];
                          final isAllowed =
                              appAllowedStatus[app.packageName] ?? false;

                          return ListTile(
                            leading: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(20), // 이미지 radius 설정
                              child: app.appImgUrl != null &&
                                      app.appImgUrl!.isNotEmpty
                                  ? Image.network(
                                      app.appImgUrl!,
                                      fit: BoxFit.cover,
                                      width: 48,
                                      height: 48,
                                    )
                                  : const Icon(Icons.apps, size: 48),
                            ),
                            title: Text(app.name),
                            trailing: Switch(
                              value: isAllowed,
                              onChanged: (bool value) async {
                                final appId = app.appId ?? 0;
                                final previousState =
                                    appAllowedStatus[app.packageName] ?? false;

                                setDialogState(() {
                                  appAllowedStatus[app.packageName] = value;
                                  if (value) {
                                    if (!allowedApps.any((a) =>
                                        a.packageName == app.packageName)) {
                                      setState(() {
                                        allowedApps.add(app);
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      allowedApps.removeWhere((a) =>
                                          a.packageName == app.packageName);
                                    });
                                  }
                                });

                                final success =
                                    await AvailableAppsApi.toggleAppStatus(
                                        appId, value);

                                if (!success) {
                                  setDialogState(() {
                                    appAllowedStatus[app.packageName] =
                                        previousState;
                                    if (previousState) {
                                      setState(() {
                                        allowedApps.add(app);
                                      });
                                    } else {
                                      setState(() {
                                        allowedApps.removeWhere((a) =>
                                            a.packageName == app.packageName);
                                      });
                                    }
                                  });
                                }
                              },
                              activeColor: AppColors.lilac,
                              activeTrackColor: AppColors.navy,
                              inactiveThumbColor: AppColors.darkGrey,
                              inactiveTrackColor: AppColors.grey,
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _fetchInstalledApps(StateSetter setDialogState) async {
    try {
      List<installed_app_info.AppInfo> apps =
          await InstalledApps.getInstalledApps();

      List<custom_app_info.AppInfo> tempApps = apps.map((app) {
        return custom_app_info.AppInfo(
          appId: null,
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

      setDialogState(() {
        isLoading = false;
      });
    } catch (e) {
      print('서버에 요청 중 오류 발생: $e');
      setDialogState(() {
        isLoading = false;
      });
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
          color: AppColors.white,
        ),
        clipBehavior: Clip.antiAlias,
        child: app.appImgUrl != null && app.appImgUrl!.isNotEmpty
            ? Image.network(
                app.appImgUrl!,
                fit: BoxFit.cover,
              )
            : const Icon(
                Icons.apps,
                color: AppColors.grey,
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
        child: const Icon(
          Icons.add,
          color: AppColors.grey,
          size: 24,
        ),
      ),
    );
  }
}
