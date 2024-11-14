import 'package:flutter/material.dart';
import 'package:padlock_phone/screens/common/loading_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:padlock_phone/screens/common/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // 모든 페이지의 배경을 흰색으로 설정
      ),
      home: const LoginScreen(),
    );
  }
}
