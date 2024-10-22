import 'package:flutter/material.dart';

class CounselReservationListWidget extends StatefulWidget {
  const CounselReservationListWidget({super.key});

  @override
  State<CounselReservationListWidget> createState() =>
      _CounselReservationListWidgetState();
}

class _CounselReservationListWidgetState
    extends State<CounselReservationListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('상담 예약 내역 위젯'),
    );
  }
}
