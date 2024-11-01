import 'package:flutter/material.dart';
import 'package:padlock_phone/widgets/common/declareScreen/declare_category_widget.dart';
import 'package:padlock_phone/widgets/common/declareScreen/declare_content_widget.dart';

class DeclareScreen extends StatelessWidget {
  const DeclareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            DeclareCategoryWidget(),
            DeclareContentWidget(),
            Text('제출하기 버튼은 여기서 직접 구현합니다.'),
          ],
        ),
      ),
    );
  }
}
