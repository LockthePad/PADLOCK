// apis/location_api.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class LocationApi {
  // 위치 정보 서버 전송
  static Future<void> sendLocation({
    required String apiServerUrl, // apiServerUrl 매개변수 추가
    required String token,
    required String memberId,
    required String classroomId,
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse('$apiServerUrl/location/save');
    debugPrint('서버 URL: $url');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'classroomId': classroomId,
          'memberId': memberId,
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode != 200) {
        debugPrint('위치 정보 전송 실패 - 상태 코드: ${response.statusCode}');
        throw Exception('위치 정보 전송에 실패했습니다.');
      }
      debugPrint("위치 전송 성공");
    } catch (e) {
      debugPrint("위치 전송 중 오류: $e");
      rethrow;
    }
  }
}
