import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AvailableAppsApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");
  static const _storage = FlutterSecureStorage();

  // 허용된 앱 목록을 가져오는 정적 메서드
  static Future<List<dynamic>> fetchAllowedApps() async {
    try {
      String? accessToken = await _storage.read(key: 'accessToken');
      String? classroomId = await _storage.read(key: 'classroomId');

      if (accessToken == null || classroomId == null) {
        throw Exception('Access token or classroom ID is missing');
      }

      final url = Uri.parse('$apiServerUrl/app?classroomId=$classroomId');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        print(
            'Failed to fetch allowed apps. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching allowed apps: $e');
      return [];
    }
  }
}