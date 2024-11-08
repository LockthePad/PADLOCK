import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';


class MemberApiService {
  final storage = const FlutterSecureStorage();
  static String apiServerUrl = dotenv.get("API_SERVER_URL");

  // 로그인
  Future<http.Response> login(String memberCode, String password) async {
    final url = Uri.parse('$apiServerUrl/login');

    final body = jsonEncode({
      'memberCode': memberCode,
      'password': password,
    });
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
      if (response.statusCode == 200) {
      debugPrint('로그인 완료');
    }
    return response;
    
  }
}
