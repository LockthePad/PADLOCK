import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:padlock_tablet/models/teacher/app_info.dart';
import 'package:padlock_tablet/models/teacher/class_info.dart';
import 'package:padlock_tablet/widgets/common/mainScreen/header_widget.dart';
import 'package:padlock_tablet/widgets/teacher/mainScreen/left_app_bar_widget.dart';
import 'package:padlock_tablet/widgets/teacher/tea_attendance_check_widget.dart';
import 'package:padlock_tablet/widgets/teacher/tea_counseling_widget.dart';
import 'package:padlock_tablet/widgets/teacher/tea_home_widget.dart';
import 'package:padlock_tablet/widgets/teacher/tea_mealInfo_widget.dart';
import 'package:padlock_tablet/widgets/teacher/tea_notification_widget.dart';
import 'package:padlock_tablet/widgets/teacher/tea_suggestion_widget.dart';
import 'package:padlock_tablet/widgets/teacher/tea_timetable_widget.dart';
import 'package:padlock_tablet/api/common/current_period_api.dart';
import 'dart:async';

class TeaMainScreen extends StatefulWidget {
  const TeaMainScreen({super.key});

  @override
  State<TeaMainScreen> createState() => _TeaMainScreenState();
}

class _TeaMainScreenState extends State<TeaMainScreen> {
  MenuItem _selectedItem = MenuItem.home;
  final storage = const FlutterSecureStorage();

  // Current period information
  ClassInfo currentClass = ClassInfo(
    date: '로딩중...',
    period: '',
    subject: '',
  );

  // Member information for header
  String memberInfo = '로딩중...';

  final List<AppInfo> availableApps = [];

  @override
  void initState() {
    super.initState();
    _loadMemberInfo();
    _fetchCurrentPeriod();
    _startPeriodicFetch();
  }

  @override
  void dispose() {
    _periodicTimer?.cancel();
    super.dispose();
  }

  Timer? _periodicTimer;

  // 주기적으로 현재 수업 정보를 업데이트
  void _startPeriodicFetch() {
    _periodicTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_selectedItem == MenuItem.home) {
        _fetchCurrentPeriod();
      }
    });
  }

  // memberInfo 불러오기
  Future<void> _loadMemberInfo() async {
    try {
      String? storedMemberInfo = await storage.read(key: 'memberInfo');
      print('Loaded memberInfo: $storedMemberInfo'); // 디버그 로그
      if (storedMemberInfo != null) {
        setState(() {
          memberInfo = storedMemberInfo;
        });
      } else {
        setState(() {
          memberInfo = '알 수 없음';
        });
      }
    } catch (e) {
      print('Error loading member info: $e');
      setState(() {
        memberInfo = '알 수 없음';
      });
    }
  }

  // 현재 수업 정보 불러오기
  Future<void> _fetchCurrentPeriod() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      String? classroomId = await storage.read(key: 'classroomId');

      print('accessToken: $accessToken, classroomId: $classroomId'); // 디버그 로그

      if (accessToken != null &&
          accessToken.isNotEmpty &&
          classroomId != null) {
        final currentPeriod = await CurrentPeriodApi.fetchCurrentPeriod(
          token: accessToken,
          classroomId: classroomId,
        );

        print(
            'Fetched current period: ${currentPeriod.date}, ${currentPeriod.period}, ${currentPeriod.subject}'); // 디버그 로그

        setState(() {
          currentClass = ClassInfo(
            date: currentPeriod.date,
            period: currentPeriod.period,
            subject: currentPeriod.subject,
          );
        });
      }
    } catch (e) {
      print('Error loading current period: $e');
      setState(() {
        currentClass = ClassInfo(
          date:
              '${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일',
          period: '오류',
          subject: '발생',
        );
      });
    }
  }

  Widget _buildContent() {
    switch (_selectedItem) {
      case MenuItem.home:
        return TeaHomeWidget(
          currentClass: currentClass,
          availableApps: availableApps,
        );
      case MenuItem.notification:
        return const TeaNotificationWidget();
      case MenuItem.attendanceCheck:
        return const TeaAttendanceCheckWidget();
      case MenuItem.timetable:
        return const TeaTimetableWidget();
      case MenuItem.mealInfo:
        return const TeaMealinfoWidget();
      case MenuItem.rightInfo:
        return TeaSuggestionWidget();
      case MenuItem.counseling:
        return const TeaCounselingWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            LeftAppBarWidget(
              selectedItem: _selectedItem,
              onItemSelected: (MenuItem newItem) {
                setState(() {
                  _selectedItem = newItem;
                });
              },
            ),
            Expanded(
              child: Column(
                children: [
                  HeaderWidget(
                    memberInfo: memberInfo,
                    isStudent: false, // Set to false for teacher
                  ),
                  Expanded(
                    child: _buildContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
