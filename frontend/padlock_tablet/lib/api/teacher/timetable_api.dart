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
  static Future<String?> addSubjectToTimetable({
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

    // 성공 처리
    if (response.statusCode == 200 || response.statusCode == 201) {
      return null; // 성공 시 null 반환
    }

    // 에러 처리
    if (response.statusCode == 400) {
      try {
        final errorResponse = jsonDecode(response.body);
        final errorCode = errorResponse['code'];
        final errorMessage = errorResponse['message'];

        if (errorCode == "4009") {
          return "마지막 교시를 넘는 시간표는 추가할 수 없습니다."; // 4009 코드에 대한 메시지
        }

        return errorMessage ?? "알 수 없는 오류 발생"; // 일반적인 400 에러 메시지
      } catch (e) {
        return "오류 응답 파싱 실패"; // 응답 파싱 실패 시
      }
    }

    return "서버 오류 발생: ${response.statusCode}"; // 기타 상태 코드 처리
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
