import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

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
    return response;
  }

  // 토큰 재발급
  Future<http.Response> refreshToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$apiServerUrl/refresh?refreshToken=$refreshToken'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      await storage.write(key: 'accessToken', value: data['accessToken']);
      await storage.write(key: 'refreshToken', value: data['refreshToken']);
    }

    return response;
  }

  // 로그아웃
  Future<void> logout(String refreshToken) async {
    try {
      await http.post(
        Uri.parse('$apiServerUrl/out?refreshToken=$refreshToken'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print("로그아웃 요청 완료");
    } catch (e) {
      print("로그아웃 요청 실패: $e");
    }
  }
}
