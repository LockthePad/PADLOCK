import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TimetableApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");

  static Future<List<Map<String, dynamic>>> fetchSchedules({
    required String token,
    required String classroomId,
  }) async {
    final url = Uri.parse('$apiServerUrl/classrooms/9/schedules');
    // final url = Uri.parse('$apiServerUrl/classrooms/$classroomId/schedules');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=utf-8',
          'Accept-Charset': 'utf-8',
        },
      );

      if (response.statusCode == 200) {
        // UTF-8로 응답 디코딩
        List<dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));

        // JSON 데이터를 Map으로 변환
        return jsonResponse
            .map((item) => {
                  'scheduleId': item['scheduleId'] as int,
                  'day': item['day'] as String,
                  'period': item['period'] as int,
                  'subject': item['subject'] as String,
                })
            .toList();
      } else {
        throw Exception('시간표를 불러오는데 실패했습니다.');
      }
    } catch (e) {
      print('Timetable API Error: $e'); // 디버깅을 위한 로그
      throw Exception('시간표를 불러오는데 실패했습니다: ${e.toString()}');
    }
  }
}
