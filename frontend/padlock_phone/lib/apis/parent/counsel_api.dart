import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CounselApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");
  static const _storage = FlutterSecureStorage();

  // teacherId 가져오기
  static Future<void> getTeacherId() async {
    try {
      String? token = await _storage.read(key: 'accessToken');
      String? classroomId = await _storage.read(key: 'selectedClassroomId');

      if (token == null) {
        throw Exception('액세스 토큰 없음');
      }

      if (classroomId == null) {
        throw Exception('교실 ID 없음');
      }

      final url = '$apiServerUrl/get-teacherId?classroomId=$classroomId';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final teacherId = int.parse(response.body); // 응답이 정수형이므로 파싱
        await _storage.write(
            key: 'selectedTeacherId', value: teacherId.toString());
        print('저장된 교사 ID: $teacherId');
      } else {
        throw Exception('교사 ID 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('교사 ID 조회 중 오류 발생: $e');
      rethrow;
    }
  }

  // 상담 가능 시간
  static Future<List<Map<String, dynamic>>> fetchCounselingData(
      String date) async {
    final url = '$apiServerUrl/counsel-available-time?date=$date';

    String? token = await _storage.read(key: 'accessToken');
    if (token == null) {
      throw Exception('액세스 토큰 없음');
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('상담 데이터 불러오기 실패');
    }
  }

  // 상담 가능 시간 상태 토글 함수
  static Future<bool> toggleCounselingStatus(int availableCounselTimeId) async {
    String? token = await _storage.read(key: 'accessToken');
    print("Access Token: $token");
    if (token == null) {
      throw Exception('액세스 토큰 없음');
    }

    final url = '$apiServerUrl/change-counsel/$availableCounselTimeId';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10));

    return response.statusCode == 200;
  }

  // 상담 신청 목록 불러오기
  static Future<List<Map<String, dynamic>>> fetchCounselingRequests() async {
    String? token = await _storage.read(key: 'accessToken');
    if (token == null) {
      throw Exception('액세스 토큰 없음');
    }

    final url = '$apiServerUrl/user-counsel';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('상담 신청 목록 불러오기 실패');
    }
  }

  // 상담 신청 취소 함수
  static Future<bool> cancelCounselingRequest(
      int parentId, int counselAvailableTimeId) async {
    String? token = await _storage.read(key: 'accessToken');
    if (token == null) {
      throw Exception('액세스 토큰 없음');
    }

    final url = '$apiServerUrl/cancel-counsel/teacher';
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "parentId": parentId,
        "counselAvailableTimeId": counselAvailableTimeId,
      }),
    );

    return response.statusCode == 200;
  }

  // 오늘의 상담 예약 현황 불러오기
  static Future<List<Map<String, dynamic>>> fetchTodayCounseling() async {
    String? token = await _storage.read(key: 'accessToken');
    if (token == null) {
      throw Exception('액세스 토큰 없음');
    }

    final url = '$apiServerUrl/today-counsel';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('오늘의 상담 예약 현황 불러오기 실패');
    }
  }
}
