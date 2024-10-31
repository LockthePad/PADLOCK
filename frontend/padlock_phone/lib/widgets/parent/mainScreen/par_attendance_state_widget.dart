import 'package:flutter/material.dart';

class ParAttendanceStateWidget extends StatefulWidget {
  const ParAttendanceStateWidget({super.key});

  @override
  State<ParAttendanceStateWidget> createState() =>
      _ParAttendanceStateWidgetState();
}

class _ParAttendanceStateWidgetState extends State<ParAttendanceStateWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text('부모님용 학생 출결현황 위젯'),
    );
  }
}
