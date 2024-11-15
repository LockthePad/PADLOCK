import 'package:flutter/material.dart';
import 'package:padlock_phone/apis/member/member_api.dart';
import 'package:padlock_phone/screens/common/login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//학생 정보 & 로그아웃

class StuUserinfoWidget extends StatelessWidget {
  const StuUserinfoWidget({
    super.key,
    required this.userName,
    required this.userClass,
    this.userImage,
  });

  final String userName;
  final String userClass;
  final String? userImage;

  @override
  Widget build(BuildContext context) {
    const storage = FlutterSecureStorage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userClass,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$userName학생',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () async {
                try {
                  final refreshToken = await storage.read(key: 'refreshToken');
                  if (refreshToken != null) {
                    await MemberApiService().logout(refreshToken);
                  }
                  await storage.deleteAll(); // 모든 저장된 데이터 삭제
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  }
                } catch (e) {
                  print("로그아웃 중 오류 발생: $e");
                  // 오류가 발생하더라도 로그인 화면으로 이동
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  }
                }
              },
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
