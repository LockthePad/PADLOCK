import 'dart:async';
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
  Timer? _locationUpdateTimer;
  bool isLoading = true; // 로딩 상태 변수

  @override
  void initState() {
    super.initState();
    _loadInitialRoute();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadInitialRoute() async {
    try {
      final routePoints = await _apiService.fetchInitialRoute();
      setState(() {
        _routePoints = routePoints;
        isLoading = false; // 로딩 완료
      });
    } catch (e) {
      print('경로 데이터 로드 중 오류 발생: $e');
      setState(() {
        isLoading = false; // 로딩 실패 시에도 로딩 종료
      });
    }
  }

  void _startLocationUpdates() {
    _locationUpdateTimer = Timer.periodic(
      const Duration(seconds: 4),
      (timer) async {
        try {
          final recentLocation = await _apiService.fetchRecentLocation();
          setState(() {
            _routePoints.add(recentLocation);
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
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(), // 로딩 애니메이션
                  SizedBox(height: 16),
                  Text('지도 로딩 중...', style: TextStyle(fontSize: 16)),
                ],
              ),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _routePoints.isNotEmpty
                    ? _routePoints.first
                    : const LatLng(36.355282585307805, 127.29851493067355),
                zoom: 17,
              ),
              polylines: {
                Polyline(
                  polylineId: const PolylineId('route'),
                  color: Colors.blue,
                  width: 5,
                  points: _routePoints,
                ),
              },
              onMapCreated: (GoogleMapController controller) {
                print('GoogleMap 렌더링 완료');
              },
            ),
    );
  }
}
