import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CounselApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");
  static const _storage = FlutterSecureStorage();

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
        final teacherId = int.parse(response.body.trim());
        await _storage.write(key: 'teacherId', value: teacherId.toString());
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
    final url = '$apiServerUrl/counsel-available-time/parent?date=$date';

    String? token = await _storage.read(key: 'accessToken');
    if (token == null) {
      throw Exception('액세스 토큰 없음');
    }

    String? teacherId = await _storage.read(key: 'teacherId');
    if (teacherId == null) {
      throw Exception('교사 ID 없음');
    }

    try {
      final response = await http.get(
        Uri.parse('$url&teacherId=$teacherId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('상담 데이터 불러오기 실패: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('요청 시간이 초과되었습니다.');
    } on Exception catch (e) {
      throw Exception('오류 발생: $e');
    }
  }

  // 상담 예약 함수
  static Future<bool> requestCounseling(int counselAvailableTimeId) async {
    try {
      // 스토리지에서 필요한 값 불러오기
      String? token = await _storage.read(key: 'accessToken');
      String? teacherId = await _storage.read(key: 'teacherId');
      String? studentId = await _storage.read(key: 'studentId');

      print("Access Token: $token");
      print("Teacher ID: $teacherId");
      print("Student ID: $studentId");

      if (token == null || teacherId == null || studentId == null) {
        throw Exception('필수 값이 누락되었습니다. (토큰, 선생님 ID, 학생 ID)');
      }

      // API URL
      final url = '$apiServerUrl/add-counsel';

      // 요청 바디
      final body = jsonEncode({
        "teacherId": int.parse(teacherId),
        "studentId": int.parse(studentId),
        "counselAvailableTimeId": counselAvailableTimeId,
      });

      // POST 요청
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      // 성공 여부 반환
      return response.statusCode == 200;
    } catch (e) {
      print("상담 예약 중 오류 발생: $e");
      return false;
    }
  }

  // 나의 상담 예약 목록을 가져오는 함수
  static Future<List<Map<String, dynamic>>> fetchReservationList() async {
    try {
      String? token = await _storage.read(key: 'accessToken');
      if (token == null) {
        throw Exception('액세스 토큰 없음');
      }

      final url = '$apiServerUrl/user-counsel';

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
        throw Exception('예약 목록 불러오기 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('나의 상담 예약 목록 조회 중 오류 발생: $e');
      rethrow;
    }
  }
}
