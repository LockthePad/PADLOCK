import 'package:flutter/material.dart';
import 'package:padlock_phone/screens/common/declare_screen.dart';
import 'package:padlock_phone/screens/common/notice_screen.dart';
import 'package:padlock_phone/screens/parent/par_counsel_screen.dart';
import 'package:padlock_phone/screens/parent/par_gps_check_screen.dart';
import 'package:padlock_phone/widgets/common/mainScreen/userinfo_widget.dart';
import 'package:padlock_phone/widgets/parent/mainScreen/par_attendance_state_widget.dart';
import 'package:padlock_phone/widgets/common/mainScreen/cardcontainer_widget.dart';

class ParMainScreen extends StatelessWidget {
  const ParMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 63),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ParGpsCheckScreen(),
                ),
              );
            },
            child: const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 19),
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 33,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 35),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: UserinfoWidget(
                    userName: "정석영",
                    userClass: "대전초 2학년 2반",
                  ),
                ),
              ),
              // SizedBox(width: 70),
              Padding(
                padding: EdgeInsets.only(right: 35),
                child: ParAttendanceStateWidget(),
              )
            ],
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ParGpsCheckScreen(),
                ),
              );
            },
            child: const CardContainer(
              subtitle: "안전한 등하교",
              title: "우리아이 위치보기",
              myicon: "backpack",
            ),
          ),
          const SizedBox(height: 7),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ParCounselScreen(),
                ),
              );
            },
            child: const CardContainer(
              subtitle: "당임선생님",
              title: "상담예약 신청하기",
              myicon: "calender",
            ),
          ),
          const SizedBox(height: 7),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoticeScreen(),
                ),
              );
            },
            child: const CardContainer(
              subtitle: "즐거운 학교생활",
              title: "공지사항 바로가기",
              myicon: "notification",
            ),
          ),
          const SizedBox(height: 7),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoticeScreen(),
                ),
              );
            },
            child: const CardContainer(
              subtitle: "즐거운 학교생활",
              title: "건의하기 바로가기",
              myicon: "notification",
            ),
          ),
        ],
      ),
    );
  }
}
