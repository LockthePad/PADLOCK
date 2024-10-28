import 'package:flutter/material.dart';
import 'package:padlock_phone/screens/common/declare_screen.dart';
import 'package:padlock_phone/screens/common/notice_screen.dart';
import 'package:padlock_phone/widgets/common/mainScreen/userinfo_widget.dart';
import 'package:padlock_phone/widgets/student/mainScreen/stu_attendance_state_widget.dart';

class StuMainScreen extends StatelessWidget {
  const StuMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('학생 메인페이지'),
      ),
      body: Column(
        children: [
          Text('학생 메인페이지입니다.'),
          UserinfoWidget(),
          StuAttendanceStateWidget(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoticeScreen(),
                ),
              );
            },
            child: Text('공지사항 페이지로 이동'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeclareScreen(),
                ),
              );
            },
            child: Text('건의하기 페이지로 이동'),
          ),
        ],
      ),
    );
  }
}
