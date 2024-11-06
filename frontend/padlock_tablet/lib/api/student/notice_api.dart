import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Notice {
  final int noticeId;
  final String title;
  final String content;
  final String createdAt;

  Notice({
    required this.noticeId,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      noticeId: json['noticeId'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: json['createdAt'] as String,
    );
  }
}

class NoticeApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");

  static Future<List<Notice>> fetchNotices({
    required String token,
    required String classroomId,
  }) async {
    final url = Uri.parse('$apiServerUrl/classrooms/$classroomId/notices');

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

        // JSON 데이터를 Notice 객체 리스트로 변환
        return jsonResponse.map((item) => Notice.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load notices');
      }
    } catch (e) {
      print('Notice API Error: $e'); // 디버깅을 위한 로그
      throw Exception('Failed to load notices: ${e.toString()}');
    }
  }
}
