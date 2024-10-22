import 'package:flutter/material.dart';

class CounselinfoWidget extends StatefulWidget {
  const CounselinfoWidget({super.key});

  @override
  State<CounselinfoWidget> createState() => _CounselinfoWidgetState();
}

class _CounselinfoWidgetState extends State<CounselinfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('상담 정보 위젯 : 어떤 선생님 ~~ 예약카드입니다.'),
    );
  }
}
