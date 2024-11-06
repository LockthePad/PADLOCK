import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MealinfoApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");

  static Future<List<Map<String, String>>> fetchMonthMeal({
    required String token,
    required String yearMonth,
    required String classroomId,
  }) async {
    final url = Uri.parse(
        '$apiServerUrl/meal/month?yearMonth=$yearMonth&classroomId=$classroomId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // API 응답이 List<Map<String, String>>이 아닌 List<Map<String, dynamic>> 형태임
        List<dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));

        // API 응답 형식에 맞게 변환
        return jsonResponse
            .map((item) => {
                  'date': item['date'] as String,
                  'menu': item['menu'] as String,
                })
            .toList();
      } else {
        throw Exception('Failed to load mealInfo data');
      }
    } catch (e) {
      throw Exception('Failed to load mealInfo data: ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> fetchDailyMeal({
    required String token,
    required String today,
    required String classroomId,
  }) async {
    final url = Uri.parse(
        '$apiServerUrl/meal/today?date=$today&classroomId=$classroomId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // API 응답이 단일 객체 형태이므로 바로 디코딩
        Map<String, dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));

        return {
          'date': jsonResponse['date'] as String,
          'menu': jsonResponse['menu'] as String,
          'allergyFood': jsonResponse['allergyFood'] as String,
          'calorie': jsonResponse['calorie'] as String,
        };
      } else {
        throw Exception('Failed to load mealInfo data');
      }
    } catch (e) {
      throw Exception('Failed to load mealInfo data: ${e.toString()}');
    }
  }
}
