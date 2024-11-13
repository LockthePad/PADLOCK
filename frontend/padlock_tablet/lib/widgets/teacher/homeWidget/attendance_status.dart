import 'package:flutter/material.dart';
import 'package:padlock_tablet/api/teacher/attendance_api.dart';
import 'package:padlock_tablet/theme/colors.dart';

class AttendanceStatus extends StatefulWidget {
  const AttendanceStatus({super.key});

  @override
  _AttendanceStatusState createState() => _AttendanceStatusState();
}

class _AttendanceStatusState extends State<AttendanceStatus> {
  int presentCount = 0;
  int absentCount = 0;
  int lateCount = 0;
  Map<String, List<String>> studentAttendanceDetails = {
    'online': [],
    'offline': [],
    'absent': [],
    'late': [], // 지각자 리스트
  };

  @override
  void initState() {
    super.initState();
    _fetchAttendanceData();
  }

  Future<void> _fetchAttendanceData() async {
    try {
      final counts = await AttendanceApi.fetchAttendanceCounts();
      final details = await AttendanceApi.fetchAttendanceDetails();

      setState(() {
        presentCount = counts['online']!;
        lateCount = counts['offline']!;
        absentCount = counts['absent']!;
        studentAttendanceDetails = details;
      });
    } catch (e) {
      print('출석 데이터 가져오기 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int total = presentCount + absentCount + lateCount;

    return GestureDetector(
      onTap: () => _showAttendanceDetailsDialog(),
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: AppColors.lilac,
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '우리반 출석현황',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildStatusCard('온라인', presentCount, AppColors.successGreen),
                  const SizedBox(height: 5),
                  _buildStatusCard('오프라인', lateCount, AppColors.yellow),
                  const SizedBox(height: 5),
                  _buildStatusCard('미출결', absentCount, AppColors.errorRed),
                ],
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              flex: 3,
              child: _buildAttendanceGraph(total),
            ),
          ],
        ),
      ),
    );
  }

  // 출석, 자리비움, 결석 카드 빌더
  Widget _buildStatusCard(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 70,
          padding: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$count명',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  // 원형 그래프 빌더
  Widget _buildAttendanceGraph(int total) {
    double presentPercentage = total > 0 ? (presentCount / total) * 100 : 0;
    double latePercentage = total > 0 ? (lateCount / total) * 100 : 0;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 130,
          height: 130,
          child: CircularProgressIndicator(
            value: 1.0, // 100%
            strokeWidth: 13,
            color: AppColors.errorRed,
            backgroundColor: AppColors.grey.withOpacity(0.3),
          ),
        ),
        SizedBox(
          width: 130,
          height: 130,
          child: CircularProgressIndicator(
            value: (presentPercentage + latePercentage) / 100,
            strokeWidth: 13,
            color: AppColors.yellow,
            backgroundColor: Colors.transparent,
          ),
        ),
        SizedBox(
          width: 130,
          height: 130,
          child: CircularProgressIndicator(
            value: presentPercentage / 100,
            strokeWidth: 13,
            color: AppColors.successGreen,
            backgroundColor: Colors.transparent,
          ),
        ),
        Text(
          '${presentPercentage.toStringAsFixed(0)}%',
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  // 출석 세부 정보 모달 다이얼로그
  void _showAttendanceDetailsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          contentPadding: const EdgeInsets.all(20),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAttendanceDetailSection(
                          '온라인',
                          studentAttendanceDetails['online']!,
                          AppColors.successGreen),
                      const SizedBox(height: 20),
                      _buildAttendanceDetailSection(
                          '오프라인',
                          studentAttendanceDetails['offline']!,
                          AppColors.yellow),
                      const SizedBox(height: 20),
                      _buildAttendanceDetailSection(
                          '미출결',
                          studentAttendanceDetails['absent']!,
                          AppColors.errorRed),
                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 30),
                      _buildAttendanceDetailSection(
                        '지각자',
                        studentAttendanceDetails['late'] ?? [],
                        AppColors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 출석 세부 정보 섹션 빌더
  Widget _buildAttendanceDetailSection(
      String title, List<String> students, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 5,
              backgroundColor: color,
            ),
            const SizedBox(width: 5),
            Text(
              '$title(${students.length}명)',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          students.join(', '),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
