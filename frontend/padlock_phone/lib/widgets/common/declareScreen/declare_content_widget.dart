import 'package:flutter/material.dart';
import 'package:padlock_phone/apis/common/declare_api.dart';
import 'package:padlock_phone/theme/colors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeclareContentWidget extends StatefulWidget {
  const DeclareContentWidget({super.key});

  @override
  State<DeclareContentWidget> createState() => _DeclareContentWidgetState();
}

class _DeclareContentWidgetState extends State<DeclareContentWidget> {
  final TextEditingController _controller = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool _isLoading = false; // 로딩 상태 추가

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // API 호출 메소드 추가
  Future<void> _submitSuggestion() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await storage.read(key: 'accessToken');

      if (token == null) {
        throw Exception('로그인이 필요합니다.');
      }

      await DeclareApi.createSuggestion(
        token: token,
        content: _controller.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('건의사항이 성공적으로 제출되었습니다.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('건의사항 제출에 실패했습니다: ${e.toString()}')),
        );
      }
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // 입력 영역
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _controller,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '건의하기 내용을 작성해주세요.',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),

          // 안내 텍스트
          const SizedBox(height: 16),
          const Text(
            '제출 후 취소는 불가하오니 확인 후 제출해주세요 !',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
            ),
          ),

          // 제출 버튼
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 65,
            child: ElevatedButton(
              onPressed:
                  _isLoading ? null : _submitSuggestion, // 로딩 중일 때는 버튼 비활성화
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text(
                      '제출하기',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 24,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
