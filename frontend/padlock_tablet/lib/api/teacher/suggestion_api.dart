import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:padlock_tablet/models/teacher/suggestion_item.dart';

class SuggestionApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");
  static const _storage = FlutterSecureStorage();

  // 건의사항 목록 불러오기
  static Future<List<SuggestionItem>> fetchSuggestions() async {
    final token = await _storage.read(key: 'accessToken');
    final classroomId = await _storage.read(key: 'classroomId');
    final url = '$apiServerUrl/classrooms/$classroomId/suggestions';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => SuggestionItem.fromJson(json)).toList();
    } else {
      throw Exception('건의사항 목록 조회 실패');
    }
  }

  // 특정 건의사항을 읽음 처리하는 함수
  static Future<bool> markAsRead(int suggestionId) async {
    final token = await _storage.read(key: 'accessToken');
    final url = '$apiServerUrl/suggestions/$suggestionId';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('읽음 처리 실패: ${response.body}');
      return false;
    }
  }
}
