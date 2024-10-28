import 'package:flutter/material.dart';
import 'package:padlock_tablet/models/students/app_info.dart';
import 'package:padlock_tablet/models/students/class_info.dart';
import 'package:padlock_tablet/models/students/meal_info.dart';
import 'package:padlock_tablet/models/students/titmetable_item.dart';
import 'package:padlock_tablet/widgets/common/mainScreen/header_widget.dart';
import 'package:padlock_tablet/widgets/student/homeWidget/menu_item.dart';
import 'package:padlock_tablet/widgets/student/mainScreen/left_app_bar_widget.dart';
import 'package:padlock_tablet/widgets/student/stu_home_widget.dart';
import 'package:padlock_tablet/widgets/student/mainScreen/left_app_bar_widget.dart';

class StuMainScreen extends StatefulWidget {
  const StuMainScreen({super.key});

  @override
  State<StuMainScreen> createState() => _StuMainScreenState();
}

class _StuMainScreenState extends State<StuMainScreen> {
  MenuItemStu _selectedItem = MenuItemStu.home;

  // 테스트 데이터
  final ClassInfo currentClass = ClassInfo(
    date: '2024년 10월 22일 화요일',
    period: '1교시',
    subject: '국어',
  );

  final List<TimeTableItem> timeTable = [
    TimeTableItem(period: '1교시', subject: '과학'),
    TimeTableItem(period: '2교시', subject: '수학'),
    TimeTableItem(period: '3교시', subject: '영어'),
    TimeTableItem(period: '4교시', subject: '음악'),
    TimeTableItem(period: '5교시', subject: '사회'),
  ];

  final MealInfo meal = MealInfo(
    dishes: [
      '백미밥',
      '돼지국밥',
      '돈육고추장볶음',
      '떡볶스',
      '상추겉절이',
      '요구르트',
    ],
  );

  final List<AppInfo> availableApps = [
    AppInfo(
      name: 'Flipnote',
      iconData: Icons.edit_note, // 노트 아이콘
      backgroundColor: Colors.red,
    ),
    AppInfo(
      name: 'Wear',
      iconData: Icons.watch, // 시계 아이콘
      backgroundColor: Colors.blue,
    ),
    AppInfo(
      name: 'Galaxy Shop',
      iconData: Icons.shopping_bag, // 쇼핑백 아이콘
      backgroundColor: Colors.blue,
    ),
  ];
  Widget _buildContent() {
    switch (_selectedItem) {
      case MenuItemStu.home:
        return StuHomeWidget(
          currentClass: currentClass,
          timeTable: timeTable,
          meal: meal,
          availableApps: availableApps,
        );
      case MenuItemStu.notification:
        return const Center(child: Text('공지사항'));
      case MenuItemStu.boardToText:
        return const Center(child: Text('필기 변환'));
      case MenuItemStu.timetable:
        return const Center(child: Text('우리반 시간표'));
      case MenuItemStu.mealInfo:
        return const Center(child: Text('오늘의 급식'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          LeftAppBarWidget(
            selectedItem: _selectedItem,
            onItemSelected: (MenuItemStu newItem) {
              setState(() {
                _selectedItem = newItem;
              });
            },
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                const HeaderWidget(
                  userName: "정석영",
                  userClass: "대전초 2학년 2반",
                  isStudent: true,
                ),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
