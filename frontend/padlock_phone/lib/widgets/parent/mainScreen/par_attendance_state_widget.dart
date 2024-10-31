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
    return Column(
      children: [
        Image.asset('assets/images/par_att_complete.png'),
        const Text(
          '출석완료',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
