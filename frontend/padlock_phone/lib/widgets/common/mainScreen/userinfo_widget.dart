import 'package:flutter/material.dart';
//학생 정보 & 로그아웃

class UserinfoWidget extends StatelessWidget {
  const UserinfoWidget({
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
    return Container(
        child: Column(
      children: [
        Text(
          userClass,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '$userName학생',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ));
  }
}
