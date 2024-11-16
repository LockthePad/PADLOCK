import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CounselinfoWidget extends StatefulWidget {
  const CounselinfoWidget({super.key});

  @override
  State<CounselinfoWidget> createState() => _CounselinfoWidgetState();
}

class _CounselinfoWidgetState extends State<CounselinfoWidget> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String schoolInfo = '학교 정보 불러오는 중...';

  @override
  void initState() {
    super.initState();
    _loadSchoolInfo();
  }

  Future<void> _loadSchoolInfo() async {
    try {
      final savedSchoolInfo = await _storage.read(key: 'schoolInfo');
      if (savedSchoolInfo != null) {
        setState(() {
          schoolInfo = savedSchoolInfo;
        });
      } else {
        setState(() {
          schoolInfo = '학교 정보 없음';
        });
      }
    } catch (e) {
      print('학교 정보 불러오기 오류: $e');
      setState(() {
        schoolInfo = '오류로 인해 정보를 가져올 수 없습니다.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          schoolInfo,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        const Text(
          '상담 예약카드입니다!',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
