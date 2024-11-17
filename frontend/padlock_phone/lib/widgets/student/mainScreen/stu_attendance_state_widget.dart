import 'package:flutter/material.dart';
import 'package:padlock_phone/theme/colors.dart';

class StuAttendanceStateWidget extends StatefulWidget {
  const StuAttendanceStateWidget({super.key, required this.attendanceStatus});

  final Map<String, dynamic> attendanceStatus;

  @override
  State<StuAttendanceStateWidget> createState() =>
      _StuAttendanceStateWidgetState();
}

class _StuAttendanceStateWidgetState extends State<StuAttendanceStateWidget> {
  String _getStatusText() {
    if (widget.attendanceStatus['away'] == true) {
      return '자리비움';
    }

    switch (widget.attendanceStatus['status']) {
      case 'PRESENT':
        return '출석 완료되었습니다.';
      case 'UNREPORTED':
        return '미체크 상태입니다.';
      case 'LATE':
        return '지각입니다.';
      case 'ABSENT':
        return '결석입니다.';
      default:
        return '로딩중...';
    }
  }

  String _getImageAsset() {
    if (widget.attendanceStatus['away'] == true) {
      return 'assets/images/att_away.png';
    } else if (widget.attendanceStatus['status'] == 'ABSENT' ||
        widget.attendanceStatus['status'] == 'UNREPORTED') {
      return 'assets/images/att_absent.png';
    } else {
      return 'assets/images/att_complete.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 15),
          Image.asset(_getImageAsset(),
              width: 270, // 이미지의 너비 고정
              height: 270, // 이미지의 높이 고정
              fit: BoxFit.contain),
          const SizedBox(height: 15),
          Text(
            _getStatusText(),
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
