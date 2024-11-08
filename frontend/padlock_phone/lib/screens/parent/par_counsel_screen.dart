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
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CounselinfoWidget(),
            SizedBox(
              height: 30,
            ),
            CounselCalenderWidget(
              onDateSelected: (selectedDate) {},
            ),
            const CounselReservationListWidget(),
          ],
        ),
      ),
    );
  }
}
