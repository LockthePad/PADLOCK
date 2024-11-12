import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:padlock_phone/apis/common/attendance_api.dart';
import 'package:padlock_phone/screens/common/notice_screen.dart';
import 'package:padlock_phone/screens/parent/par_counsel_screen.dart';
import 'package:padlock_phone/screens/parent/par_gps_check_screen.dart';
import 'package:padlock_phone/widgets/common/mainScreen/userinfo_widget.dart';
import 'package:padlock_phone/widgets/parent/mainScreen/par_attendance_state_widget.dart';
import 'package:padlock_phone/widgets/common/mainScreen/cardcontainer_widget.dart';
import 'dart:async';

class ParMainScreen extends StatefulWidget {
  const ParMainScreen({super.key});

  @override
  State<ParMainScreen> createState() => _ParMainScreenState();
}

class _ParMainScreenState extends State<ParMainScreen> {
  final storage = const FlutterSecureStorage();
  Map<String, dynamic> attendanceStatus = {
    'status': '로딩중...',
    'away': false,
  };
  Timer? _attendanceTimer;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceStatus(); // 초기 출석 상태 조회
    _startAttendanceTimer(); // 출석 상태 주기적 업데이트 시작
  }

  @override
  void dispose() {
    _attendanceTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchAttendanceStatus() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      String? studentId = await storage.read(key: 'memberId');

      debugPrint('Fetching attendance status...');
      debugPrint('AccessToken: $accessToken');
      debugPrint('StudentId: $studentId');

      if (accessToken != null && studentId != null) {
        final status = await AttendanceApi.getAttendanceStatus(
          studentId: studentId,
          token: accessToken,
        );

        debugPrint('Received status: $status');

        setState(() {
          attendanceStatus = status;
        });
      } else {
        debugPrint(
            'Missing credentials - Token: ${accessToken != null}, StudentId: ${studentId != null}');
      }
    } catch (e) {
      debugPrint('Error fetching attendance status: $e');
      setState(() {
        attendanceStatus = {
          'status': 'unreported',
          'away': false,
        };
      });
    }
  }

  void _startAttendanceTimer() {
    // 1분마다 출석 상태 업데이트
    _attendanceTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _fetchAttendanceStatus();
    });
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 35),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: UserinfoWidget(
                    userName: "정석영",
                    userClass: "대전초 2학년 2반",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 23),
                child: ParAttendanceStateWidget(
                  attendanceStatus: attendanceStatus,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
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
