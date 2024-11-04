import 'package:flutter/material.dart';
import 'package:padlock_tablet/api/teacher/counseling_api.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/models/teacher/consultation_info.dart';

class ConsultationStatus extends StatefulWidget {
  const ConsultationStatus({super.key});

  @override
  State<ConsultationStatus> createState() => _ConsultationStatusState();
}

class _ConsultationStatusState extends State<ConsultationStatus> {
  List<Consultation> consultations = [];

  // API 호출 함수
  Future<void> fetchTodayConsultations() async {
    try {
      final data = await CounselingApi.fetchTodayCounseling();
      setState(() {
        consultations = data
            .map((json) => Consultation(
                  time: json['counselAvailableTime'].substring(0, 5),
                  parentName: json['studentName'],
                ))
            .toList();
      });
    } catch (e) {
      print('Failed to load today\'s counseling data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTodayConsultations(); // 화면 초기화 시 API 호출
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 40,
        left: 40,
        right: 40,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.lilac,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽: 상담 목록
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '오늘의 상담 예약현황',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...consultations.map((consultation) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          const Icon(Icons.circle,
                              size: 8, color: AppColors.black),
                          const SizedBox(width: 10),
                          Text(
                            '${consultation.time} ${consultation.parentName} 학부모님',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          const SizedBox(width: 30),
          // 오른쪽: 캘린더 이미지
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Image.asset(
                'assets/calendar.png', // 캘린더 이미지 경로
                width: 150,
                height: 150,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
