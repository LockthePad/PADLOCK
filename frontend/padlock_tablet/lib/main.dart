import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:padlock_tablet/screens/common/loading_screen.dart';
import 'package:padlock_tablet/theme/colors.dart';
// 이거 지우지 마세요
// import 'package:padlock_tablet/widgets/kotilin/app_lock_service.dart';

void main() async {
  // 이거 지우지 마세요
  // WidgetsFlutterBinding.ensureInitialized();

  // .env 파일 로드
  await dotenv.load(fileName: ".env");

  // 이거 지우지 마세요
  // 앱 잠금 서비스 초기화
  // await AppLockService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
      ),
      home: const LoadingScreen(),
    );
  }
}
