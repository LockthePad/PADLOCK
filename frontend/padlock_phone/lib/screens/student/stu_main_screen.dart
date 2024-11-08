//배포파일에서도 위치 전송됨. (다른 앱 실행 시도 되지만 화면 꺼진경우 안됨.)

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:padlock_phone/apis/gps/location_api.dart';
import 'package:padlock_phone/screens/common/declare_screen.dart';
import 'package:padlock_phone/screens/common/notice_screen.dart';
import 'package:padlock_phone/widgets/common/mainScreen/userinfo_widget.dart';
import 'package:padlock_phone/widgets/student/mainScreen/stu_attendance_state_widget.dart';
import 'package:padlock_phone/widgets/common/mainScreen/cardcontainer_widget.dart';
import 'package:padlock_phone/screens/common/bell_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:padlock_phone/screens/student/ble_test.dart';
import 'package:permission_handler/permission_handler.dart';

// 최상위 레벨에 알림 채널 설정 함수 추가
Future<void> initializeNotifications() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'location_service_channel', // id
    'Location Service', // name
    description: 'Background location service notification', // description
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

// **최상위 레벨에 onStartBackground 함수 정의**
@pragma('vm:entry-point')
void onStartBackground(ServiceInstance service) async {
  try {
    await initializeNotifications();

    debugPrint('onStartBackground 함수 실행됨');

    // SharedPreferences를 사용하여 데이터 가져오기
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    final memberId = preferences.getString('memberId');
    final classroomId = preferences.getString('classroomId');
    final apiServerUrl = preferences.getString('apiServerUrl');

    if (token == null ||
        memberId == null ||
        classroomId == null ||
        apiServerUrl == null) {
      debugPrint('백그라운드 서비스에 필요한 데이터가 없습니다.');
      return;
    }

    debugPrint(
        "onStartBackground에서 데이터 수신 - token: $token, memberId: $memberId, classroomId: $classroomId, apiServerUrl: $apiServerUrl");

    // 위치 권한 확인 및 요청
    LocationPermission permission = await Geolocator.checkPermission();
    debugPrint('현재 위치 권한 상태: $permission');

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      debugPrint('위치 권한 요청 결과: $permission');

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        debugPrint("위치 권한이 거부되었습니다.");
        return;
      }
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("위치 서비스가 비활성화되어 있습니다.");
      return;
    }

    // 위치 정보 주기적으로 서버에 전송
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        debugPrint('백그라운드에서 위치 정보 가져오기 시도...');
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        debugPrint(
            '백그라운드에서 위치 확인됨: ${position.latitude}, ${position.longitude}');

        // 위치 정보를 서버로 전송
        await LocationApi.sendLocation(
          apiServerUrl: apiServerUrl, // 전달받은 apiServerUrl 사용
          token: token,
          memberId: memberId,
          classroomId: classroomId,
          latitude: position.latitude,
          longitude: position.longitude,
        );
        debugPrint("백그라운드에서 위치 정보 전송 성공");
      } catch (e) {
        debugPrint("백그라운드에서 위치 정보 전송 중 오류: $e");
      }
    });
  } catch (e, stackTrace) {
    debugPrint('백그라운드 서비스 오류 발생: $e');
    debugPrint('스택 트레이스: $stackTrace');
  }
}

class StuMainScreen extends StatefulWidget {
  const StuMainScreen({super.key});

  @override
  State<StuMainScreen> createState() => _StuMainScreenState();
}

class _StuMainScreenState extends State<StuMainScreen> {
  final storage = const FlutterSecureStorage();
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    _initializeStudentFeatures();
  }

  @override
  void dispose() {
    // 타이머 해제
    _locationTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeStudentFeatures() async {
    await requestLocationPermissions();
    debugPrint('학생 계정 확인, 위치 정보 전송 시작');

    // 로그인 시 저장된 토큰 및 정보 가져오기
    String? accessToken = await storage.read(key: 'accessToken');
    String? memberId = await storage.read(key: 'memberId');
    String? classroomId = await storage.read(key: 'classroomId');

    if (accessToken != null && memberId != null && classroomId != null) {
      // 위치 정보 전송 시작
      startSendingLocationData(accessToken, memberId, classroomId);
      // 백그라운드 서비스 초기화
      initializeService(accessToken, memberId, classroomId);
      debugPrint('백그라운드 서비스 초기화 진행 중');
    } else {
      debugPrint('토큰 또는 사용자 정보가 없습니다.');
    }
  }

  Future<void> requestLocationPermissions() async {
    try {
      // 위치 권한 요청
      PermissionStatus status = await Permission.location.status;
      if (status.isDenied || status.isRestricted) {
        status = await Permission.location.request();
        if (status.isDenied) {
          // 권한 거부됨
          debugPrint("위치 권한이 거부되었습니다.");
          return;
        }
      }

      // 백그라운드 위치 권한 요청 (Android 10 이상)
      if (await Permission.locationAlways.isDenied) {
        status = await Permission.locationAlways.request();
        if (status.isDenied) {
          // 권한 거부됨
          debugPrint("백그라운드 위치 권한이 거부되었습니다.");
          return;
        }
      }

      // 알림 권한 요청 (Android 13 이상)
      if (await Permission.notification.isDenied) {
        status = await Permission.notification.request();
        if (status.isDenied) {
          debugPrint("알림 권한이 거부되었습니다.");
          return;
        }
      }
    } catch (e, stackTrace) {
      debugPrint("권한 요청 중 예외 발생: $e");
      debugPrint("스택 트레이스: $stackTrace");
    }
  }

  // 위치 정보 전송 시작 함수
  void startSendingLocationData(
      String token, String memberId, String classroomId) {
    _locationTimer =
        Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
      try {
        debugPrint('포그라운드에서 위치 정보 가져오기 시도...');
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        debugPrint(
            '포그라운드에서 위치 확인됨: ${position.latitude}, ${position.longitude}');

        // 위치 정보를 서버로 전송
        await LocationApi.sendLocation(
          apiServerUrl: dotenv.get("API_SERVER_URL"), // dotenv에서 직접 가져옴
          token: token,
          memberId: memberId,
          classroomId: classroomId,
          latitude: position.latitude,
          longitude: position.longitude,
        );
        debugPrint("포그라운드에서 위치 정보 전송 성공");
      } catch (e) {
        debugPrint("포그라운드에서 위치 정보 전송 중 오류: $e");
      }
    });
  }

  // 백그라운드 위치 서비스 초기화 함수
  Future<void> initializeService(
      String token, String memberId, String classroomId) async {
    try {
      debugPrint('백그라운드 서비스 설정 시작...');
      final service = FlutterBackgroundService();

      await initializeNotifications();

      service.configure(
        androidConfiguration: AndroidConfiguration(
          onStart: onStartBackground,
          autoStart: true,
          isForegroundMode: true,
          notificationChannelId: 'location_service_channel',
          initialNotificationTitle: '위치 추적',
          initialNotificationContent: '위치 정보를 수집하고 있습니다',
          foregroundServiceNotificationId: 888,
        ),
        iosConfiguration: IosConfiguration(
          autoStart: true,
          onForeground: onStartBackground,
        ),
      );

      // 필요한 데이터를 공유 변수에 저장
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('token', token);
      await preferences.setString('memberId', memberId);
      await preferences.setString('classroomId', classroomId);
      await preferences.setString('apiServerUrl', dotenv.get("API_SERVER_URL"));

      await service.startService();

      debugPrint('백그라운드 서비스 시작 완료 및 데이터 전달 완료');
    } catch (e, stackTrace) {
      debugPrint('initializeService에서 예외 발생: $e');
      debugPrint('스택 트레이스: $stackTrace');
      // 예외가 발생해도 앱 흐름이 진행되도록 함
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 63),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BellScreen(),
                ),
              );
            },
            child: const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 19),
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 33,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyApp(),
                ),
              );
            },
            child: const Text("bletest"),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 50),
            child: Align(
              alignment: Alignment.centerLeft,
              child: UserinfoWidget(
                userName: "정석영",
                userClass: "대전초 2학년 2반",
              ),
            ),
          ),
          const StuAttendanceStateWidget(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoticeScreen(),
                ),
              );
            },
            child: const CardContainer(
              subtitle: "즐거운 학교생활",
              title: "공지사항 바로가기",
              myicon: "notification",
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeclareScreen(),
                ),
              );
            },
            child: const CardContainer(
              subtitle: "즐거운 학교생활",
              title: "건의하기 바로가기",
              myicon: "notification",
            ),
          ),
        ],
      ),
    );
  }
}
