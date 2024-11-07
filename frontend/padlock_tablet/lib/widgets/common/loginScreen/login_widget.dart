// 로그인 시 보여질 로그인 위젯입니다.
// 학생, 학부모 로그인에 따라 이동 페이지가 달라져야 합니다.

// 지금은 notUsed

import 'package:flutter/material.dart';
import 'package:padlock_tablet/screens/student/stu_main_screen.dart';
import 'package:padlock_tablet/screens/teacher/tea_main_screen.dart';
import 'package:padlock_tablet/widgets/kotilin/sample.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('로그인 위젯'),
          Text('공백을 위한 text'),
          GestureDetector(
            onTap: () {
              // 로그인 화면까지 되돌리기 막기 위해서 pushReplacement로 나중에 고쳐야합니다.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StuMainScreen(),
                ),
              );
            },
            child: Text('학생 메인페이지로 이동'),
          ),
          GestureDetector(
            onTap: () {
              // 로그인 화면까지 되돌리기 막기 위해서 pushReplacement로 나중에 고쳐야합니다.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeaMainScreen(),
                ),
              );
            },
            child: Text('교사 메인페이지로 이동'),
          ),
          ChromeLockWidget(),
        ],
      ),
    );
  }
}
