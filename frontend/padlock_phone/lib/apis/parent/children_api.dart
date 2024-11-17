import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChildrenApiService {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");

  // 자식 목록 조회
  Future<List<Map<String, dynamic>>> getChildren(String token) async {
    final url = Uri.parse('$apiServerUrl/children');
    const FlutterSecureStorage storage = FlutterSecureStorage();

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // UTF-8로 응답 데이터 디코딩
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        print('자식 조회 성공');
        print('자식 데이터: $data');

        // 반환된 데이터를 List<Map<String, dynamic>> 형태로 변환
        final children = List<Map<String, dynamic>>.from(data.map((child) {
          return {
            'studentId': child['studentId'] as int,
            'studentName': child['studentName'] as String,
            'schoolInfo': child['schoolInfo'] as String,
            'classroomId': child['classroomId'] as int, // classroomId 추가
          };
        }));

        // 자식 데이터 갯수를 storage에 저장
        await storage.write(
            key: 'childrenCount', value: children.length.toString());
        print('자식 데이터 개수 저장 완료: ${children.length}');

        return children;
      } else {
        print('자식 목록 조회 실패: 응답 코드 ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('자식 목록 조회 중 오류 발생: $e');
      return [];
    }
  }
}
