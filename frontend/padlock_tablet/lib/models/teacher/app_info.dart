class AppInfo {
  final int? appId; // 앱 ID, nullable
  final String name; // 앱 이름
  final String packageName; // 패키지 이름
  String? appImgUrl; // 앱 이미지 URL
  bool? deleteState; // 앱 상태, true(활성화), false(비활성화)

  AppInfo({
    this.appId,
    required this.name,
    required this.packageName,
    this.appImgUrl,
    this.deleteState,
  });
}
