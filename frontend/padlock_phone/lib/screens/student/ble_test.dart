import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final title = 'Flutter BLE Scan Demo';

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ScanResult> scanResultList = [];
  bool _isScanning = false;
  String attendanceStatus = "미출석";
  DateTime? lastDetectedTime;
  Timer? _attendanceTimer;
  Timer? _scanTimer;
  final String targetDeviceName = 'PADLOCK'; // 목표 기기 이름
  String detectionStatus = "감지되지 않음";
  String debugInfo = ""; // 디버깅 정보 저장용

  @override
  void initState() {
    super.initState();
    initBle();

    // 출석 상태 확인 타이머 설정 (5초마다)
    _attendanceTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkAttendanceStatus();
    });

    // 자동 스캔 타이머 설정 (15초마다)
    _scanTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (!_isScanning) {
        scan();
      }
    });
  }

  @override
  void dispose() {
    _attendanceTimer?.cancel();
    _scanTimer?.cancel();
    super.dispose();
  }

  void initBle() {
    FlutterBluePlus.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  void checkAttendanceStatus() {
    if (lastDetectedTime != null) {
      final difference = DateTime.now().difference(lastDetectedTime!);
      if (difference.inMinutes >= 1) {
        setState(() {
          attendanceStatus = "자리비움";
        });
      }
    }
  }

  // 광고 데이터에서 이름 감지하여 상태 업데이트
  void scan() async {
    if (!_isScanning) {
      scanResultList.clear();
      debugInfo = ""; // 디버깅 정보 초기화

      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

      FlutterBluePlus.scanResults.listen((results) {
        scanResultList = results;
        bool isDetected = false;

        for (var result in results) {
          String deviceName = result.advertisementData.localName;
          if (deviceName.isEmpty) {
            deviceName = result.device.platformName;
          }

          debugInfo += "Detected Device Name: $deviceName\n";

          if (deviceName == targetDeviceName) {
            lastDetectedTime = DateTime.now();
            isDetected = true;
            setState(() {
              attendanceStatus = "출석 완료";
              detectionStatus = "감지됨";
            });
            break; // 기기를 찾았으므로 루프 종료
          }
        }

        if (!isDetected) {
          setState(() {
            detectionStatus = "감지되지 않음";
          });
        }
        setState(() {});
      });
    } else {
      await FlutterBluePlus.stopScan();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: attendanceStatus == "출석 완료"
                ? Colors.green.shade100
                : attendanceStatus == "자리비움"
                    ? Colors.orange.shade100
                    : Colors.grey.shade100,
            child: Column(
              children: [
                Text(
                  '현재 상태: $attendanceStatus',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: attendanceStatus == "출석 완료"
                        ? Colors.green
                        : attendanceStatus == "자리비움"
                            ? Colors.orange
                            : Colors.grey,
                  ),
                ),
                if (lastDetectedTime != null)
                  Text(
                    '마지막 감지 시간: ${lastDetectedTime!.hour}시 ${lastDetectedTime!.minute}분',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                Text(
                  '기기 감지 상태: $detectionStatus',
                  style: TextStyle(
                      fontSize: 16,
                      color:
                          detectionStatus == "감지됨" ? Colors.green : Colors.red),
                ),
                const SizedBox(height: 10),
                Text(
                  '디버깅 정보:\n$debugInfo',
                  style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: scanResultList.length,
              itemBuilder: (context, index) {
                return listItem(scanResultList[index]);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        child: Icon(_isScanning ? Icons.stop : Icons.search),
      ),
    );
  }

  Widget listItem(ScanResult r) {
    String deviceName = r.advertisementData.localName;
    if (deviceName.isEmpty) {
      deviceName = r.device.platformName;
    }
    if (deviceName.isEmpty) {
      deviceName = 'Unknown Device';
    }

    return ListTile(
      title: Text(deviceName),
      subtitle: Text(r.device.remoteId.toString()),
      trailing: Text(r.rssi.toString()),
    );
  }
}
