import 'package:flutter/material.dart';
import 'package:padlock_tablet/widgets/student/mainScreen/left_app_bar_widget.dart';

class StuMainScreen extends StatefulWidget {
  const StuMainScreen({super.key});

  @override
  State<StuMainScreen> createState() => _StuMainScreenState();
}

class _StuMainScreenState extends State<StuMainScreen> {
  MenuItem _selectedItem = MenuItem.home;

  Widget _buildContent() {
    switch (_selectedItem) {
      case MenuItem.home:
        return const Center(child: Text('홈'));
      case MenuItem.notification:
        return const Center(child: Text('공지사항'));
      case MenuItem.boardToText:
        return const Center(child: Text('필기 변환'));
      case MenuItem.timetable:
        return const Center(child: Text('우리반 시간표'));
      case MenuItem.food:
        return const Center(child: Text('오늘의 급식'));
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
