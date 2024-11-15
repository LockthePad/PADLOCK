
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:padlock_phone/screens/common/login_screen.dart';
import 'package:padlock_phone/apis/member/member_api.dart';

class UserinfoWidget extends StatefulWidget {
  const UserinfoWidget({
    super.key,
    required this.userName,
    required this.userClass,
    required this.onChildSelected,
  });

  final String userName;
  final String userClass;
  final Function(Map<String, dynamic>) onChildSelected; // 자식 선택 시 호출될 콜백

  @override
  State<UserinfoWidget> createState() => _UserinfoWidgetState();
}

class _UserinfoWidgetState extends State<UserinfoWidget> {
  final storage = const FlutterSecureStorage();
  List<Map<String, dynamic>> children = [];
  String selectedChildName = '';

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    final childrenData = await storage.read(key: 'children');
    if (childrenData != null) {
      setState(() {
        children = List<Map<String, dynamic>>.from(jsonDecode(childrenData));
        if (children.isNotEmpty) {
          selectedChildName = children.first['studentName'];
          widget.onChildSelected({
            'studentId': children.first['studentId'],
            'studentName': children.first['studentName'],
            'schoolInfo': children.first['schoolInfo']
          });
        }
      });
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
            if (children.length > 1)
              DropdownButton<String>(
                value: selectedChildName,
                items: children.map((child) {
                  return DropdownMenuItem<String>(
                    value: child['studentName'],
                    child: Text('${child['studentName']} 학생'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedChildName = value!;
                    final selectedChild = children.firstWhere(
                      (child) => child['studentName'] == value,
                    );
                    widget.onChildSelected({
                      'studentId': selectedChild['studentId'],
                      'studentName': selectedChild['studentName'],
                      'schoolInfo': selectedChild['schoolInfo'],
                    });
                  });
                },
              )
            else
              Text(
                '${widget.userName} 학생',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
            const SizedBox(width: 10),
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
