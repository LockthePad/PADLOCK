import 'package:flutter/material.dart';
import 'package:padlock_phone/widgets/parent/gpsCheckScreen/gps_tracking_widget.dart';
import 'package:padlock_phone/widgets/parent/gpsCheckScreen/gps_view_widget.dart';

class ParGpsCheckScreen extends StatefulWidget {
  const ParGpsCheckScreen({super.key});

  @override
  State<ParGpsCheckScreen> createState() => _ParGpsCheckScreenState();
}

class _ParGpsCheckScreenState extends State<ParGpsCheckScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS 확인 페이지'),
      ),
      body: Column(
        children: [
          GpsTrackingWidget(),
          GpsViewWidget(),
        ],
      ),
    );
  }
}
