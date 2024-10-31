import 'package:flutter/material.dart';
import 'package:padlock_phone/screens/common/declare_screen.dart';
import 'package:padlock_phone/screens/common/notice_screen.dart';
import 'package:padlock_phone/widgets/common/mainScreen/userinfo_widget.dart';
import 'package:padlock_phone/widgets/student/mainScreen/stu_attendance_state_widget.dart';
import 'package:padlock_phone/widgets/common/mainScreen/cardcontainer_widget.dart';

class StuMainScreen extends StatelessWidget {
  const StuMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          SizedBox(height: 63),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 19),
              child: Icon(
                Icons.notifications_none_rounded,
                size: 33,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50),
            child: Align(
              alignment: Alignment.centerLeft,
              child: UserinfoWidget(
                userName: "정석영",
                userClass: "대전초 2학년 2반",
              ),
            ),
          ),
          StuAttendanceStateWidget(),
          CardContainer(
            subtitle: "즐거운 학교생활",
            title: "공지사항 바로가기",
            myicon: "notification",
          ),
          CardContainer(
            subtitle: "즐거운 학교생활",
            title: "건의하기 바로가기",
            myicon: "notification",
          ),
        ],
      ),
    );
  }
}

          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const NoticeScreen(),
          //       ),
          //     );
          //   },
          //   child: const Text('공지사항 페이지로 이동'),
          // ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const DeclareScreen(),
          //       ),
          //     );
          //   },
          //   child: const Text('건의하기 페이지로 이동'),
          // ),