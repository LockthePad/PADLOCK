import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:padlock_phone/apis/parent/counsel_api.dart';
import 'package:padlock_phone/theme/colors.dart';

class CounselReservationListWidget extends StatefulWidget {
  const CounselReservationListWidget({super.key});

  @override
  State<CounselReservationListWidget> createState() =>
      _CounselReservationListWidgetState();
}

class _CounselReservationListWidgetState
    extends State<CounselReservationListWidget> {
  final storage = const FlutterSecureStorage(); // SecureStorage 추가
  List<Map<String, dynamic>> _reservations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  // 상담 예약 목록 가져오기
  Future<void> _fetchReservations() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final data = await CounselApi.fetchReservationList();
      print('Fetched Reservations: $data'); // 응답 확인용 로그 추가

      setState(() {
        _reservations = data; // 데이터 설정
      });
    } catch (e) {
      print('Failed to fetch reservations: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('예약 목록을 가져오는 데 실패했습니다.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '나의 상담예약',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _reservations.isEmpty
                ? const Center(
                    child: Text(
                      '현재 예약된 상담이 없습니다.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    itemCount: _reservations.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final reservation = _reservations[index];
                      final date =
                          reservation['counselAvailableDate'] ?? '날짜 없음';
                      final time =
                          reservation['counselAvailableTime'] ?? '시간 없음';

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                '• $date $time',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ],
    );
  }
}
