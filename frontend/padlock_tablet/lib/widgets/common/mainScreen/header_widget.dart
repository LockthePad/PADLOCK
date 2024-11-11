import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.memberInfo,
    required this.isStudent,
  });

  final String memberInfo;
  final bool isStudent;

  Map<String, String> _parseMemberInfo() {
    print('Parsing memberInfo: $memberInfo');

    // memberInfo가 비어있거나 null이면 로딩 상태 표시
    if (memberInfo.isEmpty) {
      return {
        'userClass': '로딩중...',
        'userName': '로딩중...',
      };
    }

    try {
      final parts = memberInfo.split(' ');
      print('Split parts: $parts');

      // 최소 4개 파트가 있어야 함 (학교명, 학년, 반, 이름)
      if (parts.length >= 4) {
        final String name = parts.last; // 마지막 부분이 이름
        final String userClass =
            parts.take(parts.length - 1).join(' '); // 나머지는 학급정보

        return {
          'userClass': userClass,
          'userName': name,
        };
      }
    } catch (e) {
      print('Error parsing memberInfo: $e');
    }

    // 파싱 실패 시 기본값
    return {
      'userClass': '정보 없음',
      'userName': '정보 없음',
    };
  }

  @override
  Widget build(BuildContext context) {
    final String logoAsset =
        isStudent ? 'assets/yellowLogo.png' : 'assets/navyLogo.png';

    final userInfo = _parseMemberInfo();

    return Container(
      padding: const EdgeInsets.only(right: 50, top: 30, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            logoAsset,
            height: 30,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Container(
              //   width: 40,
              //   height: 40,
              //   decoration: const BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: AppColors.grey,
              //   ),
              //   child: const Icon(
              //     Icons.person,
              //     color: AppColors.white,
              //     size: 30,
              //   ),
              // ),
              const SizedBox(width: 12),
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
                        ? '${userInfo['userClass']} ${userInfo['userName']}'
                        : '${userInfo['userClass']} ${userInfo['userName']} 선생님',
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
