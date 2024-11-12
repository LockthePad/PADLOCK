import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:padlock_tablet/screens/teacher/tea_main_screen.dart';
import 'package:padlock_tablet/screens/student/stu_main_screen.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/api/member/member_api_service.dart';
import 'dart:convert';

import 'package:padlock_tablet/widgets/kotilin/app_lock_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _memberCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  String? errorMessage;
  bool isLoading = false;
  Timer? _tokenRefreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTokenAndAutoLogin();
    });
  }

  @override
  void dispose() {
    _tokenRefreshTimer?.cancel();
    _memberCodeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _startTokenRefreshTimer() {
    _tokenRefreshTimer?.cancel();
    // 55분마다 토큰 갱신
    _tokenRefreshTimer = Timer.periodic(const Duration(minutes: 55), (_) async {
      await _refreshTokenIfNeeded();
    });
  }

  Future<void> _refreshTokenIfNeeded() async {
    try {
      final refreshToken = await storage.read(key: 'refreshToken');
      if (refreshToken == null) {
        print('리프레시 토큰이 없습니다.');
        return;
      }

      try {
        final response = await MemberApiService().refreshToken(refreshToken);
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        // 응답 코드별 처리
        if (response.statusCode == 200) {
          final String accessToken = data['accessToken'];
          final String newRefreshToken = data['refreshToken'];

          await storage.write(key: 'accessToken', value: accessToken);
          await storage.write(key: 'refreshToken', value: newRefreshToken);
          print('토큰 갱신 성공');
        } else {
          // 에러 코드별 처리
          switch (data['code']) {
            case 4000:
              print("액세스 토큰 만료");
              // 액세스 토큰 만료시에는 리프레시 토큰으로 재시도
              break;
            case 4001:
              print("리프레시 토큰 만료");
              await _handleTokenExpiration();
              break;
            default:
              print("토큰 재발급 실패: ${data['message']}");
              throw Exception('Token refresh failed: ${data['message']}');
          }
        }
      } catch (e) {
        print("토큰 갱신 중 오류 발생: $e");
        await _handleTokenExpiration();
        throw Exception('Token refresh failed: $e');
      }
    } catch (e) {
      print("토큰 갱신 프로세스 실패: $e");
      await _handleTokenExpiration();
    }
  }

  Future<void> _handleTokenExpiration() async {
    _tokenRefreshTimer?.cancel();
    await storage.deleteAll();
    if (mounted) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  Future<void> _checkTokenAndAutoLogin() async {
    String? accessToken = await storage.read(key: 'accessToken');
    String? refreshToken = await storage.read(key: 'refreshToken');
    String? role = await storage.read(key: 'role');

    if (accessToken == null || refreshToken == null || role == null) {
      print('저장된 토큰이 없습니다. 로그인이 필요합니다.');
      return;
    }

    try {
      await _refreshTokenIfNeeded();
      _startTokenRefreshTimer();

      if (role == "TEACHER") {
        if (mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const TeaMainScreen()));
        }
      } else if (role == "STUDENT") {
        if (mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const StuMainScreen()));
        }
      }
    } catch (e) {
      print('자동 로그인 실패: $e');
      await _handleTokenExpiration();
    }
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await MemberApiService()
          .login(_memberCodeController.text, _passwordController.text);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        print('Login response data: $data');

        String rawMemberInfo = data['memberInfo'].toString();
        String memberInfo = utf8.decode(rawMemberInfo.codeUnits);

        await storage.write(key: 'accessToken', value: data['accessToken']);
        await storage.write(key: 'refreshToken', value: data['refreshToken']);
        await storage.write(key: 'role', value: data['role']);
        await storage.write(
            key: 'memberId', value: data['memberId'].toString());
        await storage.write(
            key: 'classroomId', value: data['classroomId'].toString());
        await storage.write(key: 'memberInfo', value: memberInfo);

        _startTokenRefreshTimer();

        if (data['role'] == "TEACHER") {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const TeaMainScreen()));
        } else if (data['role'] == "STUDENT") {
          // 학생으로 로그인한 경우에만 앱 잠금 서비스 초기화
          await AppLockService().initialize();

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const StuMainScreen()));
        }
      } else {
        setState(() {
          errorMessage = "아이디 또는 비밀번호를 확인하세요!!";
        });
      }
    } catch (e) {
      print("Login error: $e");
      setState(() {
        errorMessage = "로그인 중 오류가 발생했습니다.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
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
              const SizedBox(height: 20),
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
                onPressed: isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const ui.Size(double.infinity, 60),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: AppColors.white)
                    : const Text(
                        '로그인하기',
                        style: TextStyle(fontSize: 20, color: AppColors.white),
                      ),
              ),
              const SizedBox(height: 20),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                ),
              const SizedBox(height: 80),
              Image.asset('assets/yellowLogo.png'),
            ],
          ),
        ),
      ),
    );
  }
}
