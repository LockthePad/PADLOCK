import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/students/app_info.dart';

class StuAvailableAppsApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");
  static Future<List<AppInfo>> fetchAvailableApps(
      {required String classroomId}) async {
    try {
      final response = await http.get(
        Uri.parse('$apiServerUrl/app?classroomId=9'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        return jsonData
            .map((app) => AppInfo(
                  name: app['appName'],
                  backgroundColor: Colors.white,
                  packageName: app['packageName'],
                  appImgUrl: app['appImgUrl'],
                ))
            .toList();
      } else {
        throw Exception('Failed to load available apps');
      }
    } catch (e) {
      print('Error fetching available apps: $e');
      throw Exception('Failed to load available apps');
    }
  }
}
