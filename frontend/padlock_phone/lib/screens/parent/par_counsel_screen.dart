import 'package:flutter/material.dart';
import 'package:padlock_phone/theme/colors.dart';
import 'package:padlock_phone/widgets/parent/counselScreen/counsel_calender_widget.dart';
import 'package:padlock_phone/widgets/parent/counselScreen/counsel_reservation_list_widget.dart';
import 'package:padlock_phone/widgets/parent/counselScreen/counselinfo_widget.dart';

class ParCounselScreen extends StatefulWidget {
  const ParCounselScreen({super.key});

  @override
  State<ParCounselScreen> createState() => _ParCounselScreenState();
}

class _ParCounselScreenState extends State<ParCounselScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white, // 앱바의 배경색 고정
        elevation: 0, // 그림자 제거 (필요 시)
        title: const Text(''),
        centerTitle: true, // 텍스트 가운데 정렬 (옵션)
      ),
      backgroundColor: AppColors.white, // Scaffold 배경색 설정
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Column의 크기 제한
            children: [
              const CounselinfoWidget(),
              const SizedBox(height: 30),
              CounselCalenderWidget(
                onDateSelected: (selectedDate) {},
              ),
              const SizedBox(height: 30),
              const CounselReservationListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
