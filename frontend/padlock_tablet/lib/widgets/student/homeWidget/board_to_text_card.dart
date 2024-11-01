import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:padlock_tablet/screens/student/cameraScreen/camera_screen.dart';
import 'package:padlock_tablet/widgets/common/card_container.dart';

class BoardToTextCard extends StatelessWidget {
  final Function(XFile) onPictureTaken; // callback 추가

  const BoardToTextCard({
    super.key,
    required this.onPictureTaken,
  });

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
          onPictureTaken(picture); // 콜백 실행
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

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      onTap: () => _openCamera(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/camera.png', width: 125, height: 125),
          const Text(
            '필기 변환하기',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
