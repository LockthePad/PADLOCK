import 'package:flutter/material.dart';

class ParMainScreen extends StatelessWidget {
  const ParMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('부모 메인페이지'),
      ),
      body: Column(
        children: [Text('부모 메인페이지입니다.')],
      ),
    );
  }
}
