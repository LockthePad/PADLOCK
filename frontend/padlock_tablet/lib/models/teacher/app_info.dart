import 'package:flutter/material.dart';

class AppInfo {
  final String name; // 앱 이름
  final String packageName; // 패키지 이름
  final IconData iconData; // 아이콘 데이터
  final Color backgroundColor; // 배경 색상
  final String? appImgUrl; // 앱 이미지 URL (추가된 필드)

  AppInfo({
    required this.name,
    required this.packageName,
    this.iconData = Icons.apps, // 기본 아이콘 설정
    this.backgroundColor = Colors.grey, // 기본 배경 색상 설정
    this.appImgUrl, // 이미지 URL 초기화
  });
}
