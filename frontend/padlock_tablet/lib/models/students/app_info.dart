// lib/models/students/app_info.dart

import 'package:flutter/material.dart';

class AppInfo {
  final String name;
  final Color backgroundColor;
  final String packageName;
  final String appImgUrl;

  AppInfo({
    required this.name,
    required this.backgroundColor,
    required this.packageName,
    required this.appImgUrl,
  });
}
