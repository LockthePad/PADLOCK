import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:padlock_phone/apis/gps/get_location_api.dart';

class ParGpsCheckScreen extends StatefulWidget {
  const ParGpsCheckScreen({super.key});

  @override
  State<ParGpsCheckScreen> createState() => _ParGpsCheckScreenState();
}

class _ParGpsCheckScreenState extends State<ParGpsCheckScreen> {
  final ApiService _apiService = ApiService();
  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();
    _loadInitialRoute();
  }

  Future<void> _loadInitialRoute() async {
    try {
      final routePoints = await _apiService.fetchInitialRoute();
      setState(() {
        _routePoints = routePoints;
      });
    } catch (e) {
      print('경로 데이터 로드 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('우리아이 위치'),
      ),
      body: _routePoints.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(36.355282585307805, 127.29851493067355), // 기본 위치
                zoom: 17,
              ),
              polylines: {
                Polyline(
                  polylineId: const PolylineId('route'),
                  color: Colors.blue,
                  width: 5,
                  points: _routePoints, // 경로 데이터 설정
                ),
              },
            ),
    );
  }
}
