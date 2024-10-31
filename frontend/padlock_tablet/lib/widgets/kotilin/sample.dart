import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChromeLockWidget extends StatefulWidget {
  const ChromeLockWidget({super.key});

  @override
  State<ChromeLockWidget> createState() => _ChromeLockWidgetState();
}

class _ChromeLockWidgetState extends State<ChromeLockWidget> {
  static const platform = MethodChannel('app_lock_channel');
  bool isLocked = false;

  Future<void> _checkAndRequestPermission() async {
    try {
      final bool hasPermission =
          await platform.invokeMethod('checkAccessibilityPermission');
      if (!hasPermission) {
        await platform.invokeMethod('requestAccessibilityPermission');
      }
    } on PlatformException catch (e) {
      print("Failed to get permission: '${e.message}'.");
    }
  }

  Future<void> _checkLockState() async {
    try {
      final bool lockState = await platform.invokeMethod('getLockState');
      setState(() {
        isLocked = lockState;
      });
    } on PlatformException catch (e) {
      print("Failed to get lock state: '${e.message}'.");
    }
  }

  Future<void> _toggleLock() async {
    try {
      if (!isLocked) {
        // 잠금을 활성화할 때 권한 체크
        await _checkAndRequestPermission();
      }

      final bool newLockState = await platform.invokeMethod('toggleLock');
      setState(() {
        isLocked = newLockState;
      });
    } on PlatformException catch (e) {
      print("Failed to toggle lock: '${e.message}'.");
    }
  }

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermission();
    _checkLockState(); // 초기 상태 확인
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isLocked ? '앱 잠금이 활성화되었습니다' : '앱 잠금이 비활성화되었습니다',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _toggleLock,
            style: ElevatedButton.styleFrom(
              backgroundColor: isLocked ? Colors.red : Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isLocked ? '잠금해제' : '잠금',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
