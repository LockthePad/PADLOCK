import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/api/teacher/suggestion_api.dart';

class SuggestionDetailModal extends StatelessWidget {
  final int suggestionId; // suggestionId 추가
  final String content;
  final String timestamp;
  final String author;
  final VoidCallback onReadUpdate; // 읽음 처리 후 UI 업데이트용 콜백 추가

  const SuggestionDetailModal({
    super.key,
    required this.suggestionId,
    required this.content,
    required this.timestamp,
    required this.author,
    required this.onReadUpdate,
  });

  Future<void> _markAsRead(BuildContext context) async {
    try {
      await SuggestionApi.markAsRead(suggestionId); // API 호출
      onReadUpdate(); // 읽음 처리 후 UI 업데이트
      Navigator.pop(context); // 모달 닫기
    } catch (e) {
      print("Error marking suggestion as read: $e");
      // 에러 처리 (필요시 사용자에게 에러 메시지 표시)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.8,
        padding:
            const EdgeInsets.only(left: 36, right: 24, top: 24, bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
                Positioned(
                  right: -12,
                  top: -12,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author and Timestamp
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.navy,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.lilac,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  author,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  timestamp,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Content
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.navy,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            content,
                            style: const TextStyle(
                              fontSize: 20,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 읽음 처리 버튼
            ElevatedButton(
              onPressed: () => _markAsRead(context), // 버튼에 읽음 처리 함수 연결
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "읽음처리",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
