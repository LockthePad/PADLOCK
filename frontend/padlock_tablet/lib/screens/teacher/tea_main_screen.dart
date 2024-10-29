import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/teacher/app_info.dart';
import 'package:padlock_tablet/models/teacher/class_info.dart';
import 'package:padlock_tablet/widgets/common/mainScreen/header_widget.dart';
import 'package:padlock_tablet/widgets/teacher/mainScreen/left_app_bar_widget.dart';
import 'package:padlock_tablet/widgets/teacher/tea_home_widget.dart';

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
        return const Center(child: Text('건의함 보기'));
      case MenuItem.counseling:
        return const Center(child: Text('학부모상담 신청현황'));
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
          // 구분선
          // const VerticalDivider(width: 1),
          // 컨텐츠 영역
          Expanded(
            child: Column(
              children: [
                const HeaderWidget(
                    userName: "채송화", userClass: "대전초 2학년 2반", isStudent: false),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
