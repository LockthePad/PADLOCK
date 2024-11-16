import 'package:flutter/material.dart';
import 'package:padlock_phone/apis/parent/counsel_api.dart';
import 'package:padlock_phone/theme/colors.dart';

class CounselReservationListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> reservations;
  final bool isLoading;
  final Future<void> Function() onCancelComplete;

  const CounselReservationListWidget({
    super.key,
    required this.reservations,
    required this.isLoading,
    required this.onCancelComplete,
  });

  Future<void> _cancelReservation(
      BuildContext context, int counselAvailableTimeId) async {
    try {
      final success = await CounselApi.cancelCounseling(counselAvailableTimeId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('상담 예약이 취소되었습니다.')),
        );
        await onCancelComplete(); // 성공 시 새로고침
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('상담 예약 취소에 실패했습니다.')),
        );
      }
    } catch (e) {
      print('취소 API 호출 중 오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('상담 예약 취소 중 오류가 발생했습니다.')),
      );
    }
  }

  void _showCancelModal(BuildContext context, int counselAvailableTimeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '예약 취소',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '정말로 예약을 취소하시겠습니까?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await _cancelReservation(
                            context, counselAvailableTimeId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        '확인',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 항상 표시되는 제목
        const Text(
          ' 나의 상담 예약',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // 로딩 중 상태
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        // 예약 목록이 비어있을 경우
        else if (reservations.isEmpty)
          const Center(
            child: Text(
              '현재 예약된 상담이 없습니다.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          )
        // 예약 목록이 있을 경우
        else
          ListView.builder(
            itemCount: reservations.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              final date = reservation['counselAvailableDate'] ?? '날짜 없음';
              final time = reservation['counselAvailableTime'] ?? '시간 없음';
              final counselAvailableTimeId =
                  reservation['counselAvailableTimeId'] ?? -1;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: AppColors.black,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            '$date $time',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: counselAvailableTimeId > 0
                          ? () =>
                              _showCancelModal(context, counselAvailableTimeId)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: counselAvailableTimeId > 0
                            ? AppColors.yellow
                            : AppColors.grey,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.white,
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
