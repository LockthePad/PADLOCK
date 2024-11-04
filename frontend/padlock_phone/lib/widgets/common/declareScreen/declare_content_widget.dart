import 'package:flutter/material.dart';
import 'package:padlock_phone/theme/colors.dart';

class DeclareContentWidget extends StatefulWidget {
  const DeclareContentWidget({super.key});

  @override
  State<DeclareContentWidget> createState() => _DeclareContentWidgetState();
}

class _DeclareContentWidgetState extends State<DeclareContentWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              onPressed: () {
                // 제출 로직 구현
                if (_controller.text.trim().isNotEmpty) {
                  // API 호출 등의 제출 로직
                  print('제출된 내용: ${_controller.text}');
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
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
