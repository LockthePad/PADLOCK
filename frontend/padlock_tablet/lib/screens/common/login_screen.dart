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
  String? errorMessage;
  bool isLoading = false;

  // newstock에서 가져온 자동로그인 코드입니다. 리프레쉬 토큰 api 만들어지면 memberApi파일에 함수 생성하고, 연결하면 됩니다.
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _asyncMethod();
  //   });
  // }

  // _asyncMethod() async {
  //   // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
  //   // 데이터가 없을때는 null을 반환
  //   userInfo = await storage.read(key: 'accessToken');
  //   String? accessToken = await storage.read(key: 'accessToken');
  //   String? refreshToken = await storage.read(key: 'refreshToken');

  //   if (accessToken == null || refreshToken == null) {
  //     print('로그인이 필요합니다');
  //     return;
  //   }

  //   final response = await MemberApiService().memberInfo();

  //   if (response.statusCode == 200) {
  //     print('accessToken이 만료되었습니다. 토큰을 재발급합니다.');
  //     await MemberApiService().refreshToken(refreshToken);

  //     final retryResponse = await MemberApiService().memberInfo();

  //     if (retryResponse.statusCode == 200) {
  //       print('토큰 재발급 후 회원 정보 조회 성공');
  //       // 회원 정보가 성공적으로 조회되면 메인 화면으로 이동
  //       Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(builder: (_) => const MainScreen()));
  //     } else {
  //       print('재발급 후 회원 정보 조회 실패');
  //     }
  //   } else if (response.statusCode == 200) {
  //     print("토큰 유효 확인 성공");
  //     Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (_) => const MainScreen()));
  //   }
  //   setState(() {});
  // }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await MemberApiService()
          .login(_memberCodeController.text, _passwordController.text);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        print('Login response data: $data');

        // memberInfo UTF-8 디코딩
        String rawMemberInfo = data['memberInfo'].toString();
        String memberInfo = utf8.decode(rawMemberInfo.codeUnits);

        print('Decoded memberInfo: $memberInfo');

        await storage.write(key: 'accessToken', value: data['accessToken']);
        await storage.write(key: 'refreshToken', value: data['refreshToken']);
        await storage.write(key: 'role', value: data['role']);
        await storage.write(
            key: 'memberId', value: data['memberId'].toString());
        await storage.write(
            key: 'classroomId', value: data['classroomId'].toString());
        await storage.write(key: 'memberInfo', value: memberInfo);

        if (data['role'] == "TEACHER") {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const TeaMainScreen()));
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
              SizedBox(
                height: 20,
              ),
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
