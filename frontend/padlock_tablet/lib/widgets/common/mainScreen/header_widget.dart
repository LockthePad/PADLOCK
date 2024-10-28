import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.userName,
    required this.userClass,
    required this.isStudent,
    this.userImage,
  });

  final String userName;
  final String userClass;
  final bool isStudent;
  final String? userImage;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor =
        isStudent ? const Color(0xFFFFA726) : const Color(0xFF353B66);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE8ECF4),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 왼쪽 Padlock 로고
          Text(
            'PADLOCK',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min, // Row가 필요한 만큼만 차지하도록
            children: [
              // 프로필 이미지
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  image: userImage != null
                      ? DecorationImage(
                          image: NetworkImage(userImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: userImage == null
                    ? Icon(
                        Icons.person,
                        color: Colors.grey[600],
                        size: 30,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // 상태 및 이름 정보
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isStudent)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '출석완료',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    isStudent
                        ? '$userClass $userName'
                        : '$userClass $userName 선생님',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
