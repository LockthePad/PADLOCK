import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Note {
  final List<String> content;
  final String date;

  Note({
    required this.content,
    required this.date,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      content: List<String>.from(json['content']),
      date: json['date'],
    );
  }

  Map<String, dynamic> toSavingNote() {
    final processedContent = content
        .map((str) {
          return str
              .replaceAll(RegExp(r'[\[\]]'), '') // [] 제거
              .replaceAll('\\n', '\n') // \n을 실제 줄바꿈으로 변환
              .replaceAll('1', '') // 숫자 1 제거
              .replaceAll('3579', '') // 숫자 3579 제거
              .replaceAll('%', '') // % 제거
              .replaceAll('=', '') // = 제거
              .trim(); // 앞뒤 공백 제거
        })
        .where((str) => str.isNotEmpty)
        .join('\n'); // 빈 문자열 제거하고 각 항목 사이에 줄바꿈 추가

    return {
      'content': processedContent,
      'timestamp': date,
    };
  }
}

class PullNotesApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");

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
}
