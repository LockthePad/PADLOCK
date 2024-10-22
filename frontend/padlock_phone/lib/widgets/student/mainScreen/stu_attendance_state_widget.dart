import 'package:flutter/material.dart';

class StuAttendanceStateWidget extends StatefulWidget {
  const StuAttendanceStateWidget({super.key});

  @override
  State<StuAttendanceStateWidget> createState() =>
      _StuAttendanceStateWidgetState();
}

class _StuAttendanceStateWidgetState extends State<StuAttendanceStateWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: Text('학생 출석현황 위젯입니다.'),
    );
  }
}
