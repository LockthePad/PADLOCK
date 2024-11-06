import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class DeclareApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");

  // 학생 건의사항 등록
  static Future<void> createSuggestion({
    required String token,
    required String content,
  }) async {
    final response = await http.post(
      Uri.parse('$apiServerUrl/suggestions'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'content': content,
      }),
    );

    if (response.statusCode != 200) {
      debugPrint(token);
      throw Exception('건의사항 등록에 실패했습니다.');
    }
  }
}
