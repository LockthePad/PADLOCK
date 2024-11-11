import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class AttendanceApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");

  static Future<Map<String, dynamic>> getAttendanceStatus({
    required String studentId,
    required String token,
  }) async {
    final url = Uri.parse('$apiServerUrl/attendance/$studentId');
    debugPrint('Calling URL: $url'); // URL 로깅
    debugPrint('Token: $token'); // 토큰 로깅
    debugPrint('StudentId: $studentId'); // studentId 로깅

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

      debugPrint('Response status code: ${response.statusCode}'); // 응답 상태 코드 로깅
      debugPrint('Response body: ${response.body}'); // 응답 본문 로깅

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));

        debugPrint('Parsed response: $jsonResponse'); // 파싱된 응답 로깅

        return {
          'status': jsonResponse['status'],
          'away': jsonResponse['away'] ?? false,
        };
      } else {
        debugPrint('Failed with status code: ${response.statusCode}');
        debugPrint('Error response: ${response.body}');
        throw Exception('출석 상태를 불러오는데 실패했습니다. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception occurred: $e'); // 예외 상황 로깅
      throw Exception('출석 상태를 불러오는데 실패했습니다: $e');
    }
  }
}
