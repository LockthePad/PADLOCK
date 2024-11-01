import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:padlock_tablet/screens/student/cameraScreen/camera_screen.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/student/mainScreen/stu_title_widget.dart';

class StuNoteConvertWidget extends StatefulWidget {
  const StuNoteConvertWidget({
    Key? key,
    this.picture,
    required this.onPictureTaken, // 콜백 추가
  }) : super(key: key);
  final XFile? picture;
  final Function(XFile) onPictureTaken;

  @override
  State<StuNoteConvertWidget> createState() => _StuNoteConvertWidgetState();
}

class _StuNoteConvertWidgetState extends State<StuNoteConvertWidget> {
  String? ocrResult;

  @override
  void initState() {
    super.initState();
    if (widget.picture != null) {
      _processImage();
    }
  }

  Future<void> _processImage() async {
    // TODO: OCR API 호출
    setState(() {
      ocrResult = "< 물의 순환 >\n\n"
          "1. 물의 상태 변화\n"
          "- 증발: 끓는점 미만의 온도에서 액체 표면의 원자나 분자가 기화\n"
          "- 응결: 기체인 수증기가 액체인 물이 되는 현상\n"
          "2. 물의 순환 과정\n"
          "- 바다 → 구름 → 비 → 강 → 바다\n"
          "3. 물이 순환하며 지구의 날씨에 미치는 영향";
    });
  }

  Future<void> _saveData() async {
    // TODO: 저장 API 호출
    if (ocrResult != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장되었습니다.')),
      );
      Navigator.pop(context);
    }
  }

  void _handleCameraAction() {
    Navigator.pop(context);
  }

  Future<void> _openCamera(BuildContext context) async {
    try {
      final cameras = await availableCameras();
      if (context.mounted) {
        final XFile? picture = await Navigator.push<XFile>(
          context,
          MaterialPageRoute(
            builder: (_) => CameraPage(cameras: cameras),
          ),
        );

        if (picture != null) {
          widget.onPictureTaken(picture); // 콜백 실행
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('카메라를 실행할 수 없습니다.')),
        );
      }
    }
  }

  Widget _buildImageSection() {
    if (widget.picture == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 100,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            '현재 이미지가 없습니다.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      );
    }

    return Image.file(
      File(widget.picture!.path),
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          const StuTitleWidget(title: '필기 변환하기'),
          const SizedBox(height: 15),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 좌측 OCR 결과
                Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              '변환 결과를 확인해보세요!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              widget.picture == null
                                  ? '현재 이미지가 없습니다.'
                                  : (ocrResult ?? '변환 중...'),
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 1,
                  height: double.infinity,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(width: 8),
                // 우측 이미지 및 버튼
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _buildImageSection(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            if (widget.picture != null) ...[
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _openCamera(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    side: const BorderSide(color: Colors.black),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    '다시찍기',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _saveData,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    backgroundColor: AppColors.paleYellow,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text('저장하기'),
                                ),
                              ),
                            ] else
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _handleCameraAction,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    backgroundColor: AppColors.paleYellow,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text('사진찍기'),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
