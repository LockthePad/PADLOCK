import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:padlock_tablet/api/common/current_period_api.dart';
import 'package:intl/intl.dart';

class OcrApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");

  static Future<List<String>> performOCR(String token, XFile imageFile) async {
    final url = Uri.parse('$apiServerUrl/ocr');

    try {
      // Create multipart request
      var request = http.MultipartRequest('POST', url);

      // Add headers with UTF-8 charset
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json; charset=utf-8',
        'Accept-Charset': 'utf-8',
      });

      // XFile을 MultipartFile로 변환
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        // UTF-8로 에러 메시지 디코딩
        Map<String, dynamic> errorData =
            jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception('Failed to perform OCR: ${errorData['message']}');
      }

      // UTF-8로 응답 데이터 디코딩
      Map<String, dynamic> responseData =
          jsonDecode(utf8.decode(response.bodyBytes));

      // 디버깅을 위한 로그 추가
      print('Raw response: ${response.body}');
      print('Decoded response: $responseData');

      // 텍스트 배열을 UTF-8로 처리
      List<String> extractedText = List<String>.from(responseData['text'])
          .map((text) => utf8.decode(utf8.encode(text)))
          .toList();

      return extractedText;
    } catch (e) {
      print('OCR API Error: $e'); // 디버깅을 위한 로그 추가
      throw Exception('Failed to perform OCR: ${e.toString()}');
    }
  }

  static String _generateCreateDate(CurrentPeriodInfo currentClass) {
    final now = DateTime.now();
    final koreanWeekday = _getKoreanWeekday(now.weekday);
    final time = DateFormat('HH:mm').format(now);

    // currentClass에서 period와 subject 추출
    final period = currentClass.period;
    final subject = currentClass.subject;

    return "${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')} $time $koreanWeekday $period $subject";
  }

  static String _getKoreanWeekday(int weekday) {
    const Map<int, String> weekdays = {
      1: '월요일',
      2: '화요일',
      3: '수요일',
      4: '목요일',
      5: '금요일',
      6: '토요일',
      7: '일요일',
    };
    return weekdays[weekday] ?? '';
  }

  // OCR 결과 저장 API 호출
  static Future<void> saveOcrResult({
    required String token,
    required List<String> content,
    required CurrentPeriodInfo currentClass,
  }) async {
    final url = Uri.parse('$apiServerUrl/ocr/save');

    try {
      final createDate = _generateCreateDate(currentClass);

      final Map<String, dynamic> requestBody = {
        "content": content,
        "createDate": createDate,
      };

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=utf-8',
          'Accept-Charset': 'utf-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode != 200) {
        Map<String, dynamic> errorData =
            jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception('Failed to save OCR result: ${errorData['message']}');
      }

      // 성공적으로 저장됨
      print('OCR result saved successfully');
    } catch (e) {
      print('Save OCR API Error: $e');
      throw Exception('Failed to save OCR result: ${e.toString()}');
    }
  }
}
