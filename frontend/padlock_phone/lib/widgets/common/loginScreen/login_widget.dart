// 로그인 시 보여질 로그인 위젯입니다.
// 학생, 학부모 로그인에 따라 이동 페이지가 달라져야 합니다.

import 'package:flutter/material.dart';
import 'package:padlock_phone/screens/parent/par_main_screen.dart';
import 'package:padlock_phone/screens/student/stu_main_screen.dart';
import 'package:padlock_phone/theme/colors.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/LOGIN.png'),
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                        color: AppColors.yellow), // 비활성화 시 테두리 색상
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                        color: AppColors.yellow, width: 2.0), // 포커스 시 테두리 색상
                  ),
                  labelText: '이메일',
                  labelStyle:
                      const TextStyle(color: Color.fromRGBO(132, 132, 132, 1)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 18)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                      color: AppColors.yellow), // 비활성화 시 테두리 색상
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                      color: AppColors.yellow, width: 2.0), // 포커스 시 테두리 색상
                ),
                labelText: '비밀번호',
                labelStyle:
                    const TextStyle(color: Color.fromRGBO(132, 132, 132, 1)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: SizedBox(
              width: double.infinity, // 부모 위젯의 너비를 최대화
              child: ElevatedButton(
                onPressed: () {
                  // 로그인 로직을 여기에 추가
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StuMainScreen(),
                      // builder: (context) => const ParMainScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: AppColors.yellow, // 버튼 배경색
                ),
                child: const Text(
                  '로그인하기',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // 텍스트 색상
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
