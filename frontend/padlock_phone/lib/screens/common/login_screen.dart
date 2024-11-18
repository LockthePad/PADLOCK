import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:padlock_phone/apis/common/notification_service_api.dart';
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
  String? errorMessage;
  bool isLoading = false;
  Timer? _tokenRefreshTimer;
  final NotificationServiceApi _notificationService = NotificationServiceApi();

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
    _notificationService.dispose();
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

        if (response.statusCode == 200) {
          final String accessToken = data['accessToken'];
          final String newRefreshToken = data['refreshToken'];

          await storage.write(key: 'accessToken', value: accessToken);
          await storage.write(key: 'refreshToken', value: newRefreshToken);
          print('토큰 갱신 성공');
        } else {
          switch (data['code']) {
            case 4000:
              print("액세스 토큰 만료");
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
    _notificationService.dispose(); // 알림 서비스 정리
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

    // 토큰이 유효하면 알림 구독 시작
    await _notificationService.subscribeToNotifications();

    try {
      await _refreshTokenIfNeeded();
      _startTokenRefreshTimer();

      if (role == "PARENTS") {
        if (mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ParMainScreen()));
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

        await storage.write(key: 'accessToken', value: data['accessToken']);
        await storage.write(key: 'refreshToken', value: data['refreshToken']);
        await storage.write(key: 'role', value: data['role']);
        await storage.write(key: 'memberInfo', value: data['memberInfo']);
        await storage.write(
            key: 'memberId', value: data['memberId'].toString());
        await storage.write(
            key: 'selectedClassroomId', value: data['classroomId'].toString());
        await storage.write(
            key: 'classroomId', value: data['classroomId'].toString());

        _startTokenRefreshTimer();

        await _notificationService.subscribeToNotifications();

        if (data['role'] == "PARENTS") {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ParMainScreen()));
        } else if (data['role'] == "STUDENT") {
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
                  onPressed: isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: Size(double.infinity, buttonHeight),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: AppColors.white)
                      : const Text(
                          '로그인하기',
                          style:
                              TextStyle(fontSize: 18, color: AppColors.white),
                        ),
                ),
                if (errorMessage != null)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.02),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
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
