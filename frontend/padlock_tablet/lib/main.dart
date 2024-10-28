import 'package:flutter/material.dart';
import 'package:padlock_tablet/screens/common/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // 모든 페이지의 배경을 흰색으로 설정
      ),
      home: const LoadingScreen(),
    );
  }
}
