import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:padlock_tablet/theme/colors.dart';

class CameraForOcr extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraForOcr({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  @override
  State<CameraForOcr> createState() => _CameraForOcrState();
}

class _CameraForOcrState extends State<CameraForOcr> {
  late CameraController _controller;
  bool _isCameraInitialized = false;
  bool _isRearCameraSelected = true;
  double _minZoomLevel = 1.0;
  double _maxZoomLevel = 1.0;
  double _currentZoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(
      widget.cameras[_isRearCameraSelected ? 0 : 1],
      ResolutionPreset.high,
    );

    await _controller.initialize();

    if (_controller.value.isInitialized) {
      _minZoomLevel = await _controller.getMinZoomLevel();
      _maxZoomLevel = await _controller.getMaxZoomLevel();

      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _isCameraInitialized
            ? Stack(
                children: [
                  // 카메라 프리뷰 (90도 회전)
                  Center(
                    child: Container(
                      constraints: const BoxConstraints.expand(),
                      child: AspectRatio(
                        aspectRatio: 1 / _controller.value.aspectRatio,
                        child: Transform.rotate(
                          angle: 90 * 3.1415927 / 180, // 90도를 라디안으로 변환
                          child: CameraPreview(_controller),
                        ),
                      ),
                    ),
                  ),

                  // 줌 슬라이더
                  Positioned(
                    top: 20,
                    right: 20,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Container(
                        width: 250,
                        child: Slider(
                          value: _currentZoomLevel,
                          min: _minZoomLevel,
                          max: _maxZoomLevel,
                          activeColor: AppColors.yellow,
                          inactiveColor: Colors.white70,
                          onChanged: (value) async {
                            setState(() {
                              _currentZoomLevel = value;
                            });
                            await _controller.setZoomLevel(value);
                          },
                        ),
                      ),
                    ),
                  ),

                  // 하단 컨트롤 버튼들
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // 카메라 전환 버튼
                          IconButton(
                            onPressed: () async {
                              setState(() {
                                _isCameraInitialized = false;
                                _isRearCameraSelected = !_isRearCameraSelected;
                              });
                              await _initializeCamera();
                            },
                            icon: const Icon(
                              Icons.cameraswitch,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),

                          // 촬영 버튼
                          GestureDetector(
                            onTap: () async {
                              try {
                                XFile rawImage =
                                    await _controller.takePicture();
                                if (mounted) {
                                  Navigator.pop(context, rawImage);
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('사진 촬영 중 오류가 발생했습니다.'),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.yellow,
                                  shape: BoxShape.circle,
                                ),
                                margin: const EdgeInsets.all(8),
                              ),
                            ),
                          ),

                          // 뒤로가기 버튼
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.yellow),
                ),
              ),
      ),
    );
  }
}
