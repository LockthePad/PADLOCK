import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Note {
  final List<String> content;
  final String date;
  final int ocrId; // ocrId 필드 추가

  Note({
    required this.content,
    required this.date,
    required this.ocrId, // 생성자에 ocrId 추가
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      content: List<String>.from(json['content']),
      date: json['date'],
      ocrId: json['ocrId'], // JSON에서 ocrId 파싱
    );
  }

  Map<String, dynamic> toSavingNote() {
    final processedContent = content
        .map((str) {
          return str
              .replaceAll(RegExp(r'[\[\]]'), '')
              .replaceAll('\\n', '\n')
              .replaceAll('1', '')
              .replaceAll('3579', '')
              .replaceAll('%', '')
              .replaceAll('=', '')
              .trim();
        })
        .where((str) => str.isNotEmpty)
        .join('\n');

    return {
      'content': processedContent,
      'timestamp': date,
      'ocrId': ocrId, // ocrId 포함
    };
  }
}

class NoteApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");

  // 기존의 노트 조회 API
  static Future<List<Note>> fetchNotes({
    required String token,
  }) async {
    final url = Uri.parse('$apiServerUrl/ocr');

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
        final List<dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse
            .map((noteJson) => Note.fromJson(noteJson as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load notes: ${response.statusCode}');
      }
    } catch (e) {
      print('Pull Notes API Error: $e');
      throw Exception('Failed to load notes: ${e.toString()}');
    }
  }

  // 노트 삭제 API
  static Future<bool> deleteNote({
    required String token,
    required int ocrId,
  }) async {
    final url = Uri.parse('$apiServerUrl/ocr?ocrId=$ocrId');
    print('Delete API URL: $url'); // URL 확인
    print('Using token: $token'); // 토큰 확인

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=utf-8',
          'Accept-Charset': 'utf-8',
        },
      );

      print('Delete API Response Status: ${response.statusCode}'); // 상태 코드 확인
      print('Delete API Response Body: ${response.body}'); // 응답 본문 확인

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Delete Note API Error: Status ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Delete Note API Error: $e');
      return false;
    }
  }
}
