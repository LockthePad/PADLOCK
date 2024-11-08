import 'package:flutter/material.dart';

class CounselinfoWidget extends StatefulWidget {
  const CounselinfoWidget({super.key});

  @override
  State<CounselinfoWidget> createState() => _CounselinfoWidgetState();
}

class _CounselinfoWidgetState extends State<CounselinfoWidget> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('대전초 2학년 2반 채송화선생님',
            style: TextStyle(
              fontSize: 18,
            )),
        SizedBox(
          height: 3,
        ),
        Text(
          '상담 예약카드입니다!',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
