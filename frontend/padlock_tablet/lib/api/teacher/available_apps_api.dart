import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:padlock_tablet/models/teacher/app_info.dart';

class AvailableAppsApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");
  static const _storage = FlutterSecureStorage();

  // 허용된 앱 목록 가져오기
  static Future<List<AppInfo>> fetchAllowedApps() async {
    try {
      String? classroomId = await _storage.read(key: 'classroomId');

      final url = Uri.parse('$apiServerUrl/app?classroomId=$classroomId');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data
            .map((app) => AppInfo(
                  appId: app['appId'],
                  name: app['appName'] ?? 'Unknown App',
                  packageName: app['packageName'] ?? 'unknown.package',
                  appImgUrl: app['appImgUrl'],
                ))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // 크롤링 요청
  static Future<List<AppInfo>> postInstalledApps(List<AppInfo> apps) async {
    try {
      String? token = await _storage.read(key: 'accessToken');
      int? classroomId =
          int.tryParse(await _storage.read(key: 'classroomId') ?? '0');

      final url = Uri.parse('$apiServerUrl/app');
      final List<Map<String, dynamic>> appData = apps.map((app) {
        return {
          'classroomId': classroomId,
          'appName': app.name.toString(),
          'packageName': app.packageName.toString(),
        };
      }).toList();

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(appData),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data
            .map((app) => AppInfo(
                  appId: app['appId'],
                  name: app['appName'],
                  packageName: app['packageName'],
                  appImgUrl: app['appImgUrl'],
                ))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // 앱 상태 토글 요청
  static Future<bool> toggleAppStatus(int appId, bool newStatus) async {
    String? token = await _storage.read(key: 'accessToken');
    String? classroomId =
        await _storage.read(key: 'classroomId'); // classroomId 불러오기

    try {
      final url = Uri.parse('$apiServerUrl/app');
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'classroomId': int.parse(classroomId ?? '0'), // classroomId 추가
          'appId': appId,
          'newStatus': newStatus, // 변경할 상태
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to toggle app status. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error toggling app status: $e');
      return false;
    }
  }
}
