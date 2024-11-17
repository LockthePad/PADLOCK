import 'dart:async'; // Timer를 사용하기 위해 추가
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
  Timer? _locationUpdateTimer; // Timer를 저장할 변수

  @override
  void initState() {
    super.initState();
    _loadInitialRoute(); // 초기 경로 데이터 로드
    _startLocationUpdates(); // 주기적 위치 업데이트 시작
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel(); // Timer 해제
    super.dispose();
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

  void _startLocationUpdates() {
    _locationUpdateTimer = Timer.periodic(
      const Duration(seconds: 10), // 10초마다 실행
      (timer) async {
        try {
          final recentLocation = await _apiService.fetchRecentLocation();
          setState(() {
            _routePoints.add(recentLocation); // 새 위치를 경로에 추가
          });
        } catch (e) {
          print('최신 위치 업데이트 중 오류 발생: $e');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _routePoints.isNotEmpty
              ? _routePoints.first // 경로의 첫 지점을 기본 위치로 설정
              : const LatLng(36.355282585307805, 127.29851493067355), // 기본 위치
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
