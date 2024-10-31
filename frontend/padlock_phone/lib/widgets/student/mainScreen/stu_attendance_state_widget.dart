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
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/images/att_complete.png'),
            const SizedBox(height: 20),
            const Text(
              '출석 완료되었습니다.',
              style: TextStyle(fontSize: 18),
            )
          ],
        ));
  }
}
