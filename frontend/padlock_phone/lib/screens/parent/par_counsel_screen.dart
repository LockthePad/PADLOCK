import 'package:flutter/material.dart';
import 'package:padlock_phone/apis/parent/counsel_api.dart';
import 'package:padlock_phone/widgets/parent/counselScreen/counsel_calender_widget.dart';
import 'package:padlock_phone/widgets/parent/counselScreen/counsel_reservation_list_widget.dart';
import 'package:padlock_phone/widgets/parent/counselScreen/counselinfo_widget.dart';

class ParCounselScreen extends StatefulWidget {
  const ParCounselScreen({super.key});

  @override
  State<ParCounselScreen> createState() => _ParCounselScreenState();
}

class _ParCounselScreenState extends State<ParCounselScreen> {
  List<Map<String, dynamic>> _reservations = []; // 예약 리스트 상태
  bool _isLoading = true; // 로딩 상태

  // 상담 예약 목록 가져오기
  Future<void> _fetchReservations() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final data = await CounselApi.fetchReservationList();
      setState(() {
        _reservations = data;
      });
    } catch (e) {
      print('Failed to fetch reservations: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('예약 목록을 가져오는 데 실패했습니다.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchReservations(); // 화면 초기화 시 예약 리스트 가져오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(''),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CounselinfoWidget(),
              SizedBox(
                height: 30,
              ),
              CounselCalenderWidget(
                onDateSelected: (selectedDate) {
                  print('Selected date: $selectedDate');
                },
                onReservationComplete: _fetchReservations, // 예약 완료 시 새로고침
              ),
              const SizedBox(height: 30),
              // 예약 리스트 위젯
              CounselReservationListWidget(
                reservations: _reservations,
                isLoading: _isLoading,
                onCancelComplete: _fetchReservations, // 취소 완료 시 새로고침
              ),
            ],
          ),
        ),
      ),
    );
  }
}
