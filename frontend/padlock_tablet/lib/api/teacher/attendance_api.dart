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
        throw Exception('엑세스 토큰 또는 클래스룸 ID가 없습니다.');
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
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

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
        print('출석 데이터를 불러오는데 실패했습니다. 상태 코드: ${response.statusCode}');
        return {'online': 0, 'offline': 0, 'absent': 0};
      }
    } catch (e) {
      print('출석 데이터 가져오기 중 오류 발생: $e');
      return {'online': 0, 'offline': 0, 'absent': 0};
    }
  }

  static Future<Map<String, List<String>>> fetchAttendanceDetails() async {
    try {
      String? accessToken = await _storage.read(key: 'accessToken');
      String? classroomId = await _storage.read(key: 'classroomId');

      if (accessToken == null || classroomId == null) {
        throw Exception('엑세스 토큰 또는 클래스룸 ID가 없습니다.');
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
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        List<String> onlineStudents = [];
        List<String> offlineStudents = [];
        List<String> absentStudents = [];
        List<String> lateStudents = [];

        for (var record in data) {
          String studentName = record['studentName'] ?? '알 수 없음';
          if (record['status'] == 'PRESENT' || record['status'] == 'LATE') {
            if (record['away'] == false) {
              onlineStudents.add(studentName);
            } else {
              offlineStudents.add(studentName);
            }
          }
          if (record['status'] == 'LATE') {
            lateStudents.add(studentName);
          } else if (record['status'] == 'ABSENT' ||
              record['status'] == 'UNREPORTED') {
            absentStudents.add(studentName);
          }
        }

        return {
          'online': onlineStudents,
          'offline': offlineStudents,
          'absent': absentStudents,
          'late': lateStudents,
        };
      } else {
        print('출석 데이터 로드 실패, 상태 코드: ${response.statusCode}');
        return {
          'online': [],
          'offline': [],
          'absent': [],
          'late': [],
        };
      }
    } catch (e) {
      print('출석 데이터를 가져오는 중 오류 발생: $e');
      return {
        'online': [],
        'offline': [],
        'absent': [],
        'late': [],
      };
    }
  }
}
