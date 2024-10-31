import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/teacher/app_info.dart';
import 'package:padlock_tablet/models/teacher/class_info.dart';
import 'package:padlock_tablet/widgets/teacher/mainScreen/header_widget.dart';
import 'package:padlock_tablet/widgets/teacher/mainScreen/left_app_bar_widget.dart';
import 'package:padlock_tablet/widgets/teacher/tea_counseling_widget.dart';
import 'package:padlock_tablet/widgets/teacher/tea_home_widget.dart';
import 'package:padlock_tablet/widgets/teacher/tea_suggestion_widget.dart';

class TeaMainScreen extends StatefulWidget {
  const TeaMainScreen({super.key});

  @override
  State<TeaMainScreen> createState() => _TeaMainScreenState();
}

class _TeaMainScreenState extends State<TeaMainScreen> {
  MenuItem _selectedItem = MenuItem.home;

  // 테스트 데이터
  final ClassInfo currentClass = ClassInfo(
    date: '2024년 10월 22일 화요일',
    period: '1교시',
    subject: '국어',
  );

  final List<AppInfo> availableApps = [
    AppInfo(
      name: 'Flipnote',
      iconData: Icons.edit_note,
      backgroundColor: Colors.red,
    ),
    AppInfo(
      name: 'Wear',
      iconData: Icons.watch,
      backgroundColor: Colors.blue,
    ),
    AppInfo(
      name: 'Galaxy Shop',
      iconData: Icons.shopping_bag,
      backgroundColor: Colors.blue,
    ),
  ];

  // 건의함 데이터
  final List<Map<String, dynamic>> suggestions = [
    {
      'content': '자리 바꾸고 싶어요.',
      'timestamp': '2024.10.23 10:59',
      'author': '정석영',
      'isRead': false,
    },
    {
      'content': '책상이 삐걱거려요.',
      'timestamp': '2024.10.22 14:30',
      'author': '홍수인',
      'isRead': true,
    },
    {
      'content': '창문 고쳐주세요.',
      'timestamp': '2024.10.21 09:20',
      'author': '김철수',
      'isRead': false,
    },
    {
      'content': '자리 바꾸고 싶어요.',
      'timestamp': '2024.10.23 10:59',
      'author': '정석영',
      'isRead': false,
    },
    {
      'content': '책상이 삐걱거려요.',
      'timestamp': '2024.10.22 14:30',
      'author': '홍수인',
      'isRead': true,
    },
    {
      'content': '창문 고쳐주세요.',
      'timestamp': '2024.10.21 09:20',
      'author': '김철수',
      'isRead': false,
    },
    {
      'content': '자리 바꾸고 싶어요.',
      'timestamp': '2024.10.23 10:59',
      'author': '정석영',
      'isRead': false,
    },
    {
      'content': '책상이 삐걱거려요.',
      'timestamp': '2024.10.22 14:30',
      'author': '홍수인',
      'isRead': true,
    },
    {
      'content': '창문 고쳐주세요.',
      'timestamp': '2024.10.21 09:20',
      'author': '김철수',
      'isRead': false,
    },
  ];

  // 상담 예약 데이터
  final List<Map<String, dynamic>> counselingRequests = [
    {'date': '2024년 10월 21일', 'time': '16시 00분', 'parentName': '홍길동'},
    {'date': '2024년 10월 22일', 'time': '16시 30분', 'parentName': '김철수'},
    {'date': '2024년 10월 23일', 'time': '17시 00분', 'parentName': '이영희'},
    {'date': '2024년 10월 21일', 'time': '16시 00분', 'parentName': '홍길동'},
    {'date': '2024년 10월 22일', 'time': '16시 30분', 'parentName': '김철수'},
    {'date': '2024년 10월 23일', 'time': '17시 00분', 'parentName': '이영희'},
    {'date': '2024년 10월 21일', 'time': '16시 00분', 'parentName': '홍길동'},
    {'date': '2024년 10월 22일', 'time': '16시 30분', 'parentName': '김철수'},
    {'date': '2024년 10월 23일', 'time': '17시 00분', 'parentName': '이영희'},
    {'date': '2024년 10월 21일', 'time': '16시 00분', 'parentName': '홍길동'},
    {'date': '2024년 10월 22일', 'time': '16시 30분', 'parentName': '김철수'},
    {'date': '2024년 10월 23일', 'time': '17시 00분', 'parentName': '이영희'},
    {'date': '2024년 10월 21일', 'time': '16시 00분', 'parentName': '홍길동'},
    {'date': '2024년 10월 22일', 'time': '16시 30분', 'parentName': '김철수'},
    {'date': '2024년 10월 23일', 'time': '17시 00분', 'parentName': '이영희'},
  ];

  Widget _buildContent() {
    switch (_selectedItem) {
      case MenuItem.home:
        return TeaHomeWidget(
          currentClass: currentClass,
          availableApps: availableApps,
        );
      case MenuItem.notification:
        return const Center(child: Text('공지사항'));
      case MenuItem.attendanceCheck:
        return const Center(child: Text('우리반 출석현황'));
      case MenuItem.timetable:
        return const Center(child: Text('우리반 시간표'));
      case MenuItem.mealInfo:
        return const Center(child: Text('이번달 급식'));
      case MenuItem.rightInfo:
        return TeaSuggestionWidget(suggestions: suggestions);
      case MenuItem.counseling:
        // Counseling 데이터 전달
        return TeaCounselingWidget(counselingRequests: counselingRequests);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // LeftAppBarWidget
            LeftAppBarWidget(
              selectedItem: _selectedItem,
              onItemSelected: (MenuItem newItem) {
                setState(() {
                  _selectedItem = newItem;
                });
              },
            ),
            // 컨텐츠 영역
            Expanded(
              child: Column(
                children: [
                  const HeaderWidget(
                    userName: "채송화",
                    userClass: "대전초 2학년 2반",
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
