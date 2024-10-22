// 로그인 페이지입니다.
// 로그인 컴포넌트가 별도로 있으니 로그인 위젯에서 생성한 후 import해와서 쓰면 됩니다.

import 'package:flutter/material.dart';
import 'package:padlock_phone/widgets/common/loginScreen/login_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // column 대신에 scaffold를 쓰는게 나을 수도 있습니다.
    return Column(
      children: [
        Expanded(child: LoginWidget()),
      ],
    );
  }
}
