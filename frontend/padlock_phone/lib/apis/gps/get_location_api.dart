import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static String apiServerUrl = dotenv.get('API_SERVER_URL'); // 환경변수에서 URL 가져오기

  // SecureStorage에서 accessToken 가져오기
  Future<String?> _getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  // SecureStorage에서 studentId 가져오기
  Future<String?> _getStudentId() async {
    return await _storage.read(key: 'studentId');
  }

  Future<List<LatLng>> fetchInitialRoute() async {
    final accessToken = await _getAccessToken();
    final studentId = await _getStudentId();
    print('학생 아이디 : $studentId');

    if (accessToken == null || studentId == null) {
      print('fetchInitialRoute: accessToken 또는 studentId가 없습니다.');
      throw Exception('accessToken 또는 studentId가 없습니다.');
    }

    final url = Uri.parse('$apiServerUrl/location/total?studentId=$studentId');
    print('fetchInitialRoute: API 요청 시작 - $url');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    print('fetchInitialRoute: 응답 상태코드 - ${response.statusCode}');
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      print('fetchInitialRoute: 응답 데이터 - $jsonResponse');
      return jsonResponse
          .map((point) => LatLng(point['latitude'], point['longitude']))
          .toList();
    } else {
      throw Exception('Failed to fetch initial route: ${response.statusCode}');
    }
  }

  // 최신 위치 가져오기
  Future<LatLng> fetchRecentLocation() async {
    final accessToken = await _getAccessToken();
    final studentId = await _getStudentId();

    if (accessToken == null || studentId == null) {
      throw Exception('accessToken 또는 studentId가 없습니다.');
    }

    final url = Uri.parse('$apiServerUrl/location/recent?studentId=$studentId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json; charset=utf-8',
        'Accept-Charset': 'utf-8',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(utf8.decode(response.bodyBytes));
      return LatLng(jsonResponse['latitude'], jsonResponse['longitude']);
    } else {
      throw Exception('Failed to fetch recent location');
    }
  }
}
