import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:padlock_phone/apis/member/member_api.dart';
import 'package:padlock_phone/screens/parent/par_main_screen.dart';
import 'package:padlock_phone/screens/student/stu_main_screen.dart';
import 'package:padlock_phone/theme/colors.dart';
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

        if (role == "PARENTS") {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ParMainScreen()));
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
    // 화면 크기에 따른 반응형 크기 설정
    final screenSize = MediaQuery.of(context).size;
    final loginImageSize = screenSize.width * 0.5; // 화면 너비의 50%
    final buttonHeight = screenSize.height * 0.07; // 화면 높이의 7%
    final bottomLogoSize = screenSize.width * 0.4; // 화면 너비의 40%

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        // 스크롤 가능하도록 변경
        child: SafeArea(
          // SafeArea 추가
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.1), // 화면 너비의 10% 패딩
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenSize.height * 0.1), // 상단 여백
                Image.asset(
                  'assets/images/LOGIN.png',
                  width: loginImageSize,
                  height: loginImageSize,
                ),
                SizedBox(height: screenSize.height * 0.03),
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
                SizedBox(height: screenSize.height * 0.02),
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
                SizedBox(height: screenSize.height * 0.03),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: Size(double.infinity, buttonHeight),
                  ),
                  child: const Text(
                    '로그인하기',
                    style: TextStyle(fontSize: 18, color: AppColors.white),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.08),
                Image.asset(
                  'assets/images/yellowLogo.png',
                  width: bottomLogoSize,
                ),
                SizedBox(height: screenSize.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
