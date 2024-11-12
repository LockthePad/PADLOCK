import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AttendanceApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");
  static const _storage = FlutterSecureStorage();

  static Future<Map<String, int>> fetchAttendanceCounts() async {
    try {
      String? accessToken = await _storage.read(key: 'accessToken');
      String? classroomId = await _storage.read(key: 'classroomId');

      if (accessToken == null || classroomId == null) {
        throw Exception('Access token or classroom ID is missing');
      }

      final url =
          Uri.parse('$apiServerUrl/attendances?classroomId=$classroomId');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        int onlineCount = 0;
        int offlineCount = 0;
        int absentCount = 0;

        for (var record in data) {
          if (record['status'] == 'PRESENT' || record['status'] == 'LATE') {
            if (record['away'] == false) {
              onlineCount++;
            } else {
              offlineCount++;
            }
          } else if (record['status'] == 'ABSENT' ||
              record['status'] == 'UNREPORTED') {
            absentCount++;
          }
        }

        return {
          'online': onlineCount,
          'offline': offlineCount,
          'absent': absentCount,
        };
      } else {      
        return {'online': 0, 'offline': 0, 'absent': 0};
      }
    } catch (e) {
      return {'online': 0, 'offline': 0, 'absent': 0};
    }
  }
}
