import 'package:flutter/material.dart';
import 'package:padlock_phone/screens/common/notice_screen.dart';

class StuMainScreen extends StatelessWidget {
  const StuMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('학생 메인페이지'),
      ),
      body: Column(
        children: [
          Text('학생 메인페이지입니다.'),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoticeScreen(),
                ),
              );
            },
            child: Text('공지사항 페이지로 이동'),
          ),
        ],
      ),
    );
  }
}
