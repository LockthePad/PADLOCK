import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';

class CurrentPeriodResponse {
  final String code;
  final int? period;
  final String? subject;
  final String? message;

  CurrentPeriodResponse({
    required this.code,
    this.period,
    this.subject,
    this.message,
  });

  factory CurrentPeriodResponse.fromJson(Map<String, dynamic> json) {
    return CurrentPeriodResponse(
      code: json['code'] as String,
      period: json['period'] as int?,
      subject: json['subject'] as String?,
      message: json['message'] as String?,
    );
  }

  bool get isInClass => code == 'IN_CLASS';
  bool get isBreakTime => code == 'BREAK_TIME';
  bool get isOutOfClassTime => code == 'OUT_OF_CLASS_TIME';
  bool get isNoSchedule => code == '4808';
}

class CurrentPeriodInfo {
  final String date;
  final String period;
  final String subject;
  final Color backgroundColor;

  CurrentPeriodInfo({
    required this.date,
    required this.period,
    required this.subject,
    required this.backgroundColor,
  });

  factory CurrentPeriodInfo.fromPeriodResponse(CurrentPeriodResponse response) {
    final now = DateTime.now();
    final date = '${now.year}년 ${now.month}월 ${now.day}일';

    if (response.isInClass) {
      return CurrentPeriodInfo(
        date: date,
        period: '${response.period}교시',
        subject: response.subject ?? '',
        backgroundColor: AppColors.yellow,
      );
    } else if (response.isBreakTime) {
      return CurrentPeriodInfo(
        date: date,
        period: '쉬는',
        subject: '시간',
        backgroundColor: AppColors.yellow,
      );
    } else if (response.isOutOfClassTime) {
      return CurrentPeriodInfo(
        date: date,
        period: '수업 시간',
        subject: '외',
        backgroundColor: AppColors.yellow,
      );
    } else {
      return CurrentPeriodInfo(
        date: date,
        period: '수업',
        subject: '없음',
        backgroundColor: AppColors.yellow,
      );
    }
  }
}

class CurrentPeriodApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");

  static Future<CurrentPeriodInfo> fetchCurrentPeriod({
    required String token,
    required String classroomId,
  }) async {
    final url =
        Uri.parse('$apiServerUrl/classrooms/$classroomId/current-period');
    final now = DateTime.now();
    final date = '${now.year}년 ${now.month}월 ${now.day}일';

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
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final code = jsonResponse['code'] as String;

        switch (code) {
          case 'IN_CLASS':
            return CurrentPeriodInfo(
              date: date,
              period: '${jsonResponse['period']}교시',
              subject: jsonResponse['subject'] ?? '',
              backgroundColor: AppColors.yellow,
            );
          case 'BREAK_TIME':
            return CurrentPeriodInfo(
              date: date,
              period: '쉬는',
              subject: '시간',
              backgroundColor: AppColors.yellow,
            );
          case 'OUT_OF_CLASS_TIME':
            return CurrentPeriodInfo(
              date: date,
              period: '수업 이외',
              subject: '시간',
              backgroundColor: AppColors.yellow,
            );
          default:
            return CurrentPeriodInfo(
              date: date,
              period: '수업',
              subject: '없음',
              backgroundColor: AppColors.yellow,
            );
        }
      } else {
        throw Exception('Failed to load current period');
      }
    } catch (e) {
      print('Current Period API Error: $e');
      throw Exception('Failed to load current period: ${e.toString()}');
    }
  }
}
