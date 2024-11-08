import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:padlock_tablet/models/teacher/timetable_item.dart';

class TimetableApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");
  static const _storage = FlutterSecureStorage();

  // 시간표 불러오기 함수
  static Future<List<TimetableItem>> fetchTimetable() async {
    final token = await _storage.read(key: 'accessToken');
    final classroomId = await _storage.read(key: 'classroomId');
    final url = '$apiServerUrl/classrooms/$classroomId/schedules';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => TimetableItem.fromJson(json)).toList();
    } else {
      throw Exception('시간표 조회 실패');
    }
  }

  // 시간표에 과목 추가
  static Future<bool> addSubjectToTimetable({
    required String day,
    required int period,
    required String subject,
  }) async {
    final token = await _storage.read(key: 'accessToken');
    final classroomId = await _storage.read(key: 'classroomId');

    final url = '$apiServerUrl/classrooms/$classroomId/schedules';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "day": day,
        "period": period,
        "subject": subject,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print('과목 추가 실패: ${response.body}');
      return false;
    }
  }

  // 시간표에서 과목 삭제
  static Future<bool> removeSubjectFromTimetable({
    required String day,
    required int period,
  }) async {
    final token = await _storage.read(key: 'accessToken');
    final classroomId = await _storage.read(key: 'classroomId');

    final url =
        '$apiServerUrl/classrooms/$classroomId/schedules?day=$day&period=$period';

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('과목 삭제 실패: ${response.body}');
      return false;
    }
  }
}
