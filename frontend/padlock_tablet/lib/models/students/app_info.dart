import 'package:flutter/material.dart';

class AppInfo {
  final String name;
  final IconData iconData; // iconPath 대신 IconData 사용
  final Color backgroundColor;

  AppInfo({
    required this.name,
    required this.iconData,
    required this.backgroundColor,
  });
}
