import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:padlock_tablet/models/teacher/notice_item.dart';

class NotificationApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");
  static const _storage = FlutterSecureStorage();

  // 공지사항 목록 불러오기
  static Future<List<NoticeItem>> fetchNotifications(int classroomId) async {
    final token = await _storage.read(key: 'accessToken');
    final url = '$apiServerUrl/classrooms/$classroomId/notices';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => NoticeItem.fromJson(json)).toList();
    } else {
      throw Exception('공지사항 목록 조회 실패');
    }
  }

  // 공지사항 작성 함수
  static Future<int?> createNotification(String title, String content) async {
    final token = await _storage.read(key: 'accessToken');
    final classroomId = await _storage.read(key: 'classroomId');
    final url = '$apiServerUrl/classrooms/$classroomId/notices';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "title": title,
        "content": content,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as int;
    } else {
      throw Exception('공지사항 작성 실패');
    }
  }

// 공지사항 수정하기
  static Future<void> updateNotification(
      int noticeId, String title, String content) async {
    final token = await _storage.read(key: 'accessToken');
    final url = '$apiServerUrl/notices/$noticeId';

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "title": title,
        "content": content,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('공지사항 수정 실패');
    }
  }

  // 공지사항 삭제 함수
  static Future<bool> deleteNotification(int noticeId) async {
    final token = await _storage.read(key: 'accessToken');
    final url = '$apiServerUrl/notices/$noticeId';

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('공지사항 삭제 실패: ${response.body}');
      return false;
    }
  }
}
