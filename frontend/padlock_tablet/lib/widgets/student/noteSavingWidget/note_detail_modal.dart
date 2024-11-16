import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NoteDetailModal extends StatelessWidget {
  final String content;
  final String timestamp;
  final int ocrId;
  final Function? onDelete; // Callback to update parent state after deletion

  const NoteDetailModal({
    super.key,
    required this.content,
    required this.timestamp,
    required this.ocrId,
    this.onDelete,
  });

  Future<bool> _deleteNote(BuildContext context) async {
    final apiServerUrl = dotenv.get("API_SERVER_URL");
    final url = Uri.parse('$apiServerUrl/ocr?ocrId=$ocrId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=utf-8',
          'Accept-Charset': 'utf-8',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete note: ${response.statusCode}');
      }
    } catch (e) {
      print('Delete Note API Error: $e');
      return false;
    }
  }

  String _removeQuotes(String text) {
    // 앞뒤 따옴표 제거
    if (text.startsWith('"') && text.endsWith('"')) {
      return text.substring(1, text.length - 1);
    }
    return text;
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
                      children: [
                        const SizedBox(width: 60),
                        const Text(
                          "필기 상세보기",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 10,
                      width: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.yellow,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 235,
                  top: 0,
                  child: Image(
                    image: const AssetImage('assets/pencil.png'),
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
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
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.yellow,
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
                              color: AppColors.yellow,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            timestamp,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.yellow,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            _removeQuotes(content),
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
            ElevatedButton(
              onPressed: () async {
                // 확인 다이얼로그 표시
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.white,
                    title: Column(
                      children: [
                        const Text(
                          '필기 삭제',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 6,
                          width: 100,
                          decoration: BoxDecoration(
                            color: AppColors.yellow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                    content: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.yellow.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.warning_rounded,
                              color: AppColors.yellow,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Text(
                            '이 필기를 삭제하시겠습니까?',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Container(
                        padding: const EdgeInsets.only(right: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                              child: const Text(
                                '취소',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.yellow,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                '삭제',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );

                // 사용자가 삭제를 확인한 경우
                if (shouldDelete == true && onDelete != null) {
                  onDelete!(); // 부모 컴포넌트의 삭제 함수 호출
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                '필기 삭제',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
