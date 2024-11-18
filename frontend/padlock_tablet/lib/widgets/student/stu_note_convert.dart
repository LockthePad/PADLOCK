import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:padlock_tablet/api/common/current_period_api.dart';
import 'package:padlock_tablet/api/student/ocr_api.dart';
import 'package:padlock_tablet/screens/student/cameraScreen/camera_for_ocr.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/student/mainScreen/stu_title_widget.dart';

class StuNoteConvertWidget extends StatefulWidget {
  const StuNoteConvertWidget({
    Key? key,
    this.picture,
    required this.onPictureTaken,
    required this.currentClass,
  }) : super(key: key);

  final XFile? picture;
  final Function(XFile) onPictureTaken;
  final CurrentPeriodInfo currentClass;

  @override
  State<StuNoteConvertWidget> createState() => _StuNoteConvertWidgetState();
}

class _StuNoteConvertWidgetState extends State<StuNoteConvertWidget> {
  final storage = const FlutterSecureStorage();
  String? ocrResult;
  bool isLoading = false;

  Future<void> _convertImage() async {
    if (widget.picture == null) return;

    setState(() {
      isLoading = true;
      ocrResult = null;
    });

    try {
      String? accessToken = await storage.read(key: 'accessToken');

      if (accessToken != null && accessToken.isNotEmpty) {
        try {
          final List<String> result = await OcrApi.performOCR(
            accessToken,
            widget.picture!,
          ).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('OCR 처리 시간이 초과되었습니다.');
            },
          );

          if (mounted) {
            setState(() {
              ocrResult = result.join('\n');
            });
          }
        } catch (e) {
          print('OCR Error: $e');
          rethrow;
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('인증 정보가 유효하지 않습니다. 다시 로그인해주세요.')),
          );
        }
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      if (mounted) {
        setState(() {
          ocrResult = 'OCR 처리 시간이 초과되었습니다. 다시 시도해주세요.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OCR 처리 시간이 초과되었습니다. 다시 시도해주세요.')),
        );
      }
    } catch (e) {
      print('Error converting image: $e');
      if (mounted) {
        setState(() {
          ocrResult = '이미지 변환 중 오류가 발생했습니다.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미지 변환 중 오류가 발생했습니다.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _saveData() async {
    if (ocrResult == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('먼저 이미지를 변환해주세요.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('인증 정보가 유효하지 않습니다.');
      }

      await OcrApi.saveOcrResult(
        token: accessToken,
        content: [ocrResult!],
        currentClass: widget.currentClass,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('저장되었습니다.')),
        );
      }
    } catch (e) {
      print('Save Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('저장 중 오류가 발생했습니다.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _openCamera(BuildContext context) async {
    try {
      final cameras = await availableCameras();
      if (context.mounted) {
        final XFile? picture = await Navigator.push<XFile>(
          context,
          MaterialPageRoute(
            builder: (_) => CameraForOcr(cameras: cameras),
          ),
        );

        if (picture != null) {
          widget.onPictureTaken(picture);
          setState(() {
            ocrResult = null;
          });
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

  Widget _buildOcrContent() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.yellow),
            ),
            SizedBox(height: 16),
            Text('변환 중입니다...'),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Padding(
              padding: EdgeInsets.only(left: 35),
              child: Text(
                '변환 결과를 확인해보세요!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 20),
            child: Container(
              width: double.infinity,
              height: 370,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.yellow,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  // 여기에 SingleChildScrollView 추가
                  child: Text(
                    ocrResult ?? '변환 버튼을 눌러 텍스트를 추출해주세요.',
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.8,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SizedBox(
                  width: constraints.maxHeight,
                  height: constraints.maxWidth,
                  child: Image.file(
                    File(widget.picture!.path),
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StuTitleWidget(title: '필기 변환하기'),
          const SizedBox(height: 15),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _buildOcrContent(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 1,
                  height: double.infinity,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(width: 8),
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
                        if (widget.picture != null) ...[
                          ElevatedButton(
                            onPressed: isLoading ? null : _convertImage,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: AppColors.yellow,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              isLoading ? '변환 중...' : '변환하기',
                              style: const TextStyle(color: AppColors.black),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => _openCamera(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    side: const BorderSide(
                                        color: AppColors.yellow),
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
                                  onPressed: isLoading ? null : _saveData,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    backgroundColor: AppColors.yellow,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    '저장하기',
                                    style: TextStyle(color: AppColors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else
                          ElevatedButton(
                            onPressed: () => _openCamera(context),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: AppColors.yellow,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              '사진찍기',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                              ),
                            ),
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
