// par_main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:padlock_phone/apis/common/attendance_api.dart';
import 'package:padlock_phone/apis/common/notification_service_api.dart';
import 'package:padlock_phone/apis/parent/children_api.dart';
import 'package:padlock_phone/apis/parent/counsel_api.dart';
import 'package:padlock_phone/model/common/notification_item.dart';
import 'package:padlock_phone/screens/common/notice_screen.dart';
import 'package:padlock_phone/screens/parent/par_counsel_screen.dart';
import 'package:padlock_phone/screens/parent/par_gps_check_screen.dart';
import 'package:padlock_phone/theme/colors.dart';
import 'package:padlock_phone/widgets/common/mainScreen/userinfo_widget.dart';
import 'package:padlock_phone/widgets/common/notification/notification_modal.dart';
import 'package:padlock_phone/widgets/parent/mainScreen/par_attendance_state_widget.dart';
import 'package:padlock_phone/widgets/common/mainScreen/cardcontainer_widget.dart';
import 'dart:async';
import 'dart:convert';

class ParMainScreen extends StatefulWidget {
  const ParMainScreen({super.key});

  @override
  State<ParMainScreen> createState() => _ParMainScreenState();
}

class _ParMainScreenState extends State<ParMainScreen> {
  final storage = const FlutterSecureStorage();
  final NotificationServiceApi _notificationService = NotificationServiceApi();

  Map<String, dynamic> attendanceStatus = {
    'status': '로딩중...',
    'away': false,
  };
  List<Map<String, dynamic>> children = [];
  String? selectedChildId;
  String? studentName;
  String? schoolInfo;

  Timer? _attendanceTimer;
  List<NotificationItem> _notifications = [];
  bool _hasUnreadNotifications = false;
  StreamSubscription? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadChildrenData(); // 자식 정보 로드
  }

  Future<void> _loadChildrenData() async {
    try {
      final accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print("토큰이 없습니다. 자식 정보 조회를 중단합니다.");
        return;
      }

      final childrenApiService = ChildrenApiService();
      final fetchedChildren = await childrenApiService.getChildren(accessToken);

      if (fetchedChildren.isNotEmpty) {
        setState(() {
          children = List<Map<String, dynamic>>.from(fetchedChildren);
          studentName = children.first['studentName'];
          schoolInfo = children.first['schoolInfo'];
          selectedChildId = children.first['studentId'].toString();
        });

        await storage.write(key: 'children', value: jsonEncode(children));
      } else {
        print("자식 정보가 없습니다.");
      }
    } catch (e) {
      print("자식 정보 조회 중 오류 발생: $e");
    }
  }

  Future<void> _initializeNotifications() async {
    try {
      final initialNotifications =
          await _notificationService.getNotifications();
      setState(() {
        _notifications = initialNotifications;
        _updateUnreadStatus();
      });

      _notificationSubscription =
          _notificationService.notificationStream.listen((notifications) {
        setState(() {
          _notifications = notifications;
          _updateUnreadStatus();
        });
      });
    } catch (e) {
      print('알림 초기화 오류 발생: $e');
    }
  }

  void _updateUnreadStatus() {
    final hasUnread = _notifications.any((notification) => !notification.read);
    setState(() {
      _hasUnreadNotifications = hasUnread;
    });
  }

  Future<void> _fetchAttendanceStatus() async {
    if (selectedChildId == null) return;

    try {
      final accessToken = await storage.read(key: 'accessToken');
      if (accessToken != null) {
        final status = await AttendanceApi.getAttendanceStatus(
          studentId: selectedChildId!,
          token: accessToken,
        );

        setState(() {
          attendanceStatus = status;
        });
      } else {
        print('토큰이 없습니다.');
      }
    } catch (e) {
      print('출석 상태 조회 중 오류 발생: $e');
      setState(() {
        attendanceStatus = {
          'status': 'unreported',
          'away': false,
        };
      });
    }
  }

  @override
  void dispose() {
    _attendanceTimer?.cancel();
    _notificationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 63),
            GestureDetector(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 19),
                  child: Stack(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.notifications,
                          color: _hasUnreadNotifications
                              ? AppColors.yellow
                              : AppColors.grey,
                          size: 28,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => NotificationModal(
                              notifications: _notifications,
                              notificationService: _notificationService,
                              onNotificationsRead: () => setState(() {
                                _updateUnreadStatus();
                              }),
                            ),
                          );
                        },
                      ),
                      if (_hasUnreadNotifications)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserinfoWidget(
                    userName: studentName ?? '학생',
                    userClass: schoolInfo ?? '학교 정보 없음',
                    onChildSelected: (childInfo) {
                      setState(() {
                        studentName = childInfo['studentName'];
                        schoolInfo = childInfo['schoolInfo'];
                        selectedChildId = childInfo['studentId'].toString();
                        _fetchAttendanceStatus();
                      });
                    },
                  ),
                  ParAttendanceStateWidget(
                    attendanceStatus: attendanceStatus,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (children.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: 150, // 원하는 폭 설정
                  child: DropdownButtonHideUnderline(
                    child: // DropdownButton 부분 수정
                        DropdownButton<String>(
                      value: null,
                      icon: const Icon(Icons.arrow_drop_down),
                      hint: const Text("",
                          style: TextStyle(color: Colors.black54)),
                      items: children.map((child) {
                        return DropdownMenuItem<String>(
                          value: child['studentName'],
                          child: Text('${child['studentName']} 학생'),
                        );
                      }).toList(),
                      onChanged: (value) async {
                        try {
                          final selectedChild = children.firstWhere(
                            (child) => child['studentName'] == value,
                          );

                          // classroomId 저장
                          await storage.write(
                            key: 'selectedClassroomId',
                            value: selectedChild['classroomId'].toString(),
                          );

                          // teacherId 가져와서 저장
                          await CounselApi.getTeacherId();

                          setState(() {
                            studentName = selectedChild['studentName'];
                            schoolInfo = selectedChild['schoolInfo'];
                            selectedChildId =
                                selectedChild['studentId'].toString();
                            _fetchAttendanceStatus();
                          });
                        } catch (e) {
                          print('선생님 정보 가져오기 실패: $e');
                        }
                      },
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ParGpsCheckScreen(),
                  ),
                );
              },
              child: const CardContainer(
                subtitle: "안전한 등하교",
                title: "우리아이 위치보기",
                myicon: "backpack",
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ParCounselScreen(),
                  ),
                );
              },
              child: const CardContainer(
                subtitle: "담임선생님",
                title: "상담예약 신청하기",
                myicon: "notification",
              ),
            ),
            const SizedBox(height: 20),
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
          ],
        ),
      ),
    );
  }
}
