import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:camera/camera.dart';

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
}
