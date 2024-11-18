import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:padlock_phone/screens/common/login_screen.dart';
import 'package:padlock_phone/apis/member/member_api.dart';
import 'package:padlock_phone/apis/parent/counsel_api.dart';

class UserinfoWidget extends StatefulWidget {
  const UserinfoWidget({
    super.key,
    required this.userName,
    required this.userClass,
    required this.onChildSelected,
    required this.children,
    // required this.childrenCount,
  });

  final String userName;
  final String userClass;
  // final int childrenCount;
  final List<Map<String, dynamic>> children;
  final Function(Map<String, dynamic>) onChildSelected; // 자식 선택 시 호출될 콜백

  @override
  State<UserinfoWidget> createState() => _UserinfoWidgetState();
}

class _UserinfoWidgetState extends State<UserinfoWidget> {
  final storage = const FlutterSecureStorage();
  List<Map<String, dynamic>> children = [];
  String selectedChildName = '';
  late Future<int> childrenCountFuture;

  @override
  void initState() {
    super.initState();
    if (widget.children.isNotEmpty) {
      selectedChildName = widget.children.first['studentName'].toString();
      widget.onChildSelected({
        'studentId': widget.children.first['studentId'],
        'studentName': widget.children.first['studentName'],
        'schoolInfo': widget.children.first['schoolInfo'],
      });
      print('UserinfoWidget 초기 선택된 자식: $selectedChildName');
    }
  }

  Future<int> _loadChildrenCountAndData() async {
    try {
      final childrenData = await storage.read(key: 'children');
      if (childrenData != null) {
        children = List<Map<String, dynamic>>.from(jsonDecode(childrenData));
        print('자식 데이터 로드 성공: $children');
        if (children.isNotEmpty) {
          selectedChildName = children.first['studentName'].toString();
          widget.onChildSelected({
            'studentId': children.first['studentId'],
            'studentName': children.first['studentName'],
            'schoolInfo': children.first['schoolInfo'],
          });
        }
      }

      final childrenCount = children.length;
      print('자식 데이터 개수: $childrenCount');
      return childrenCount;
    } catch (e) {
      print('자녀 정보 로드 중 오류 발생: $e');
      return 0; // 오류 시 기본값 반환
    }
  }

  @override
  void didUpdateWidget(covariant UserinfoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children != widget.children && widget.children.isNotEmpty) {
      setState(() {
        selectedChildName = widget.children.first['studentName'].toString();
        widget.onChildSelected({
          'studentId': widget.children.first['studentId'],
          'studentName': widget.children.first['studentName'],
          'schoolInfo': widget.children.first['schoolInfo'],
        });
        print('UserinfoWidget 업데이트 후 선택된 자식: $selectedChildName');
      });
    }
  }

  Future<void> _onChildChanged(String? value) async {
    if (value == null) return;
    try {
      final selectedChild = widget.children.firstWhere(
        (child) => child['studentName'].toString() == value,
      );

      // 선택된 자식 정보 저장
      await storage.write(
        key: 'selectedClassroomId',
        value: selectedChild['classroomId'].toString(),
      );

      await CounselApi.getTeacherId();

      await storage.write(
        key: 'schoolInfo',
        value: selectedChild['schoolInfo'],
      );

      await storage.write(
        key: 'studentId',
        value: selectedChild['studentId'].toString(),
      );

      setState(() {
        selectedChildName = selectedChild['studentName'].toString();
      });

      widget.onChildSelected({
        'studentId': selectedChild['studentId'],
        'studentName': selectedChild['studentName'],
        'schoolInfo': selectedChild['schoolInfo'],
      });
    } catch (e) {
      print('자녀 선택 변경 중 오류 발생: $e');
    }
  }

  Future<void> _logout() async {
    try {
      final refreshToken = await storage.read(key: 'refreshToken');
      if (refreshToken != null) {
        await MemberApiService().logout(refreshToken);
      }
      await storage.deleteAll();
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      print("로그아웃 중 오류 발생: $e");
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.userClass,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.children.length > 1)
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value:
                        selectedChildName.isNotEmpty ? selectedChildName : null,
                    items: widget.children.map((child) {
                      return DropdownMenuItem<String>(
                        value: child['studentName'],
                        child: Text(
                          '${child['studentName']} 학생',
                          style: const TextStyle(
                            fontSize: 18, // 목록에 표시되는 글자 크기
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: _onChildChanged, // 선택 변경 시 처리
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    dropdownColor: Colors.white,
                    selectedItemBuilder: (BuildContext context) {
                      return widget.children.map((child) {
                        return Text(
                          '${child['studentName']} 학생',
                          style: const TextStyle(
                            fontSize: 30, // 선택된 텍스트 글자 크기
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              )
            else
              Expanded(
                child: Text(
                  '${widget.userName} 학생',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            // const SizedBox(width: 10),
            GestureDetector(
              onTap: _logout,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Image.asset(
                  'assets/images/Logout.png',
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
