import 'package:flutter/material.dart';

class GpsViewWidget extends StatefulWidget {
  const GpsViewWidget({super.key});

  @override
  State<GpsViewWidget> createState() => _GpsViewWidgetState();
}

class _GpsViewWidgetState extends State<GpsViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('GPS상의 지난 이동경로를 표현해줄 위젯입니다.'),
    );
  }
}
