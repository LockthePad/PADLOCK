// 로딩페이지 입니다.
// 타이머로 2초 뒤에 로그인 페이지로 이동합니다.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:padlock_tablet/screens/common/login_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('로딩페이지 구현');
  }
}
