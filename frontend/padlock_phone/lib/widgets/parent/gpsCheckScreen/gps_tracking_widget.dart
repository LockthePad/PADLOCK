import 'package:flutter/material.dart';

class GpsTrackingWidget extends StatefulWidget {
  const GpsTrackingWidget({super.key});

  @override
  State<GpsTrackingWidget> createState() => _GpsTrackingWidgetState();
}

class _GpsTrackingWidgetState extends State<GpsTrackingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('GPS 현재 위치를 구현할 위젯입니다.'),
    );
  }
}
