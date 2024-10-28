import 'package:flutter/material.dart';
import 'package:padlock_tablet/widgets/teacher/mainScreen/left_app_bar_widget.dart';

class TeaMainScreen extends StatefulWidget {
  const TeaMainScreen({super.key});

  @override
  State<TeaMainScreen> createState() => _TeaMainScreenState();
}

class _TeaMainScreenState extends State<TeaMainScreen> {
  MenuItem _selectedItem = MenuItem.home;

  Widget _buildContent() {
    switch (_selectedItem) {
      case MenuItem.home:
        return const Center(child: Text('홈'));
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
      body: Row(
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
          const VerticalDivider(width: 1),
          // 컨텐츠 영역
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }
}
