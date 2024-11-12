import 'package:flutter/material.dart';
import 'package:padlock_phone/theme/colors.dart';

class ParAttendanceStateWidget extends StatefulWidget {
  const ParAttendanceStateWidget({super.key, required this.attendanceStatus});

  final Map<String, dynamic> attendanceStatus;

  @override
  State<ParAttendanceStateWidget> createState() =>
      _ParAttendanceStateWidgetState();
}

class _ParAttendanceStateWidgetState extends State<ParAttendanceStateWidget> {
  String _getStatusText() {
    if (widget.attendanceStatus['away'] == true) {
      return '자리비움';
    }

    switch (widget.attendanceStatus['status']) {
      case 'PRESENT':
        return '출석완료';
      case 'UNREPORTED':
        return '미출석';
      case 'LATE':
        return '지각';
      case 'ABSENT':
        return '결석';
      default:
        return '로딩중...';
    }
  }

  String _getImageAsset() {
    if (widget.attendanceStatus['away'] == true) {
      return 'assets/images/par_att_away.png';
    } else if (widget.attendanceStatus['status'] == 'ABSENT' ||
        widget.attendanceStatus['status'] == 'UNREPORTED') {
      return 'assets/images/par_att_absent.png';
    } else {
      return 'assets/images/par_att_complete.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120, // 부모 위젯의 공간에 맞추도록 고정 너비 설정
      child: Column(
        children: [
          Image.asset(
            _getImageAsset(),
            width: 80, // 이미지의 너비 고정
            height: 80, // 이미지의 높이 고정
            fit: BoxFit.contain, // 이미지가 영역에 맞게 조정되도록 설정
          ),
          const SizedBox(height: 5),
          Text(
            _getStatusText(),
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
