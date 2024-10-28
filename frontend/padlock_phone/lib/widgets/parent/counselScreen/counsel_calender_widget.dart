import 'package:flutter/material.dart';

class CounselCalenderWidget extends StatefulWidget {
  const CounselCalenderWidget({super.key});

  @override
  State<CounselCalenderWidget> createState() => _CounselCalenderWidgetState();
}

class _CounselCalenderWidgetState extends State<CounselCalenderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('상담 달력 위젯'),
    );
  }
}
