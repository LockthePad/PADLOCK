import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:padlock_tablet/screens/teacher/tea_main_screen.dart';
import 'package:padlock_tablet/screens/student/stu_main_screen.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/api/member/member_api_service.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _memberCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();

  Future<void> _login() async {
    final memberCode = _memberCodeController.text;
    final password = _passwordController.text;

    try {
      final response = await MemberApiService().login(memberCode, password);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        String accessToken = data['accessToken'];
        String refreshToken = data['refreshToken'];
        String role = data['role'];
        String memberId = data['memberId'].toString();
        String classroomId = data['classroomId'].toString();

        await storage.write(key: 'accessToken', value: accessToken);
        await storage.write(key: 'refreshToken', value: refreshToken);
        await storage.write(key: 'role', value: role);
        await storage.write(key: 'memberId', value: memberId);
        await storage.write(key: 'classroomId', value: classroomId);

        if (role == "TEACHER") {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const TeaMainScreen()));
        } else if (role == "STUDENT") {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const StuMainScreen()));
        }
      } else {
        print("로그인 실패 - 상태 코드: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("오류 발생: $e");
      print(stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/loginLogo.png',
                width: 250,
                height: 250,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _memberCodeController,
                decoration: InputDecoration(
                  labelText: '  아이디',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: AppColors.yellow),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: AppColors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: AppColors.yellow),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '  비밀번호',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: AppColors.yellow),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: AppColors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: AppColors.yellow),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const ui.Size(double.infinity, 60),
                ),
                child: const Text(
                  '로그인하기',
                  style: TextStyle(fontSize: 20, color: AppColors.white),
                ),
              ),
              const SizedBox(height: 100),
              Image.asset('assets/yellowLogo.png'),
            ],
          ),
        ),
      ),
    );
  }
}
