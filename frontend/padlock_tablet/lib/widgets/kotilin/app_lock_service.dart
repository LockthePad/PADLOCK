import 'package:flutter/services.dart';

class AppLockService {
  static const platform = MethodChannel('app_lock_channel');

  // 싱글톤 패턴 구현
  static final AppLockService _instance = AppLockService._internal();

  factory AppLockService() {
    return _instance;
  }

  AppLockService._internal();

  Future<void> initialize() async {
    try {
      // 접근성 권한 확인 및 요청
      final bool hasPermission =
          await platform.invokeMethod('checkAccessibilityPermission');
      if (!hasPermission) {
        await platform.invokeMethod('requestAccessibilityPermission');
      }

      // 잠금 상태 확인 후 활성화되어 있지 않다면 활성화
      final bool lockState = await platform.invokeMethod('getLockState');
      if (!lockState) {
        await platform.invokeMethod('toggleLock');
      }
    } on PlatformException catch (e) {
      print("Failed to initialize app lock: '${e.message}'.");
    }
  }
}
