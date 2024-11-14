import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class AttPostApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");

  // 비콘 상태 전송
  static Future<Map<String, dynamic>> sendBeaconStatus({
    required String accessToken,
    required bool success,
    required int classroomId,
  }) async {
    final url =
        '$apiServerUrl/communication?success=$success&classroomId=$classroomId';
    debugPrint('Calling URL: $url'); // URL 로깅
    debugPrint('classroomId: $classroomId'); // studentId 로깅

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return {
          "success": true,
          "statusCode": response.statusCode,
          "message": "POST 요청 성공"
        };
      } else {
        return {
          "success": false,
          "statusCode": response.statusCode,
          "message": "서버에서 실패 응답 수신"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "statusCode": null,
        "message": "네트워크 오류 발생: $e"
      };
    }
  }
}
