import 'package:flutter/material.dart';
import 'package:padlock_phone/screens/common/declare_screen.dart';
import 'package:padlock_phone/screens/common/notice_screen.dart';
import 'package:padlock_phone/screens/parent/par_counsel_screen.dart';
import 'package:padlock_phone/screens/parent/par_gps_check_screen.dart';
import 'package:padlock_phone/widgets/common/mainScreen/userinfo_widget.dart';
import 'package:padlock_phone/widgets/parent/mainScreen/par_attendance_state_widget.dart';

class ParMainScreen extends StatelessWidget {
  const ParMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('부모 메인페이지'),
      ),
      body: Column(
        children: [
          const Text('부모 메인페이지입니다.'),
          // UserinfoWidget(),
          const ParAttendanceStateWidget(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ParGpsCheckScreen(),
                ),
              );
            },
            child: const Text('GPS 확인 페이지로 이동'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ParCounselScreen(),
                ),
              );
            },
            child: const Text('상담예약 페이지로 이동'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoticeScreen(),
                ),
              );
            },
            child: const Text('공지사항 페이지로 이동'),
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
            child: const Text('건의하기 페이지로 이동'),
          ),
        ],
      ),
    );
  }
}
