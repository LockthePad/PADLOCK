import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';

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
    final String logoAsset =
        isStudent ? 'assets/yellowLogo.png' : 'assets/navyLogo.png';

    return Container(
      padding: const EdgeInsets.only(right: 50, top: 30, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            logoAsset,
            height: 40,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 프로필 이미지
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.grey,
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
                        color: AppColors.white,
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
                        color: AppColors.successGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '출석완료',
                        style: TextStyle(
                          color: AppColors.white,
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
