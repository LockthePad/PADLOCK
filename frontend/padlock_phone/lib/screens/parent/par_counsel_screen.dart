import 'package:flutter/material.dart';
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
        title: const Text('부모 메인페이지'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CounselinfoWidget(),
            CounselCalenderWidget(),
            CounselReservationListWidget(),
          ],
        ),
      ),
    );
  }
}
