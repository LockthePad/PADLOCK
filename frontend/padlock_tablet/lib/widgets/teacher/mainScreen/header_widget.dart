import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.userName,
    required this.userClass,
  });

  final String userName;
  final String userClass;

  @override
  Widget build(BuildContext context) {
    const String logoAsset = 'assets/navyLogo.png';

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 45, top: 35, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(logoAsset, height: 25, fit: BoxFit.contain),
          Text(
            '$userClass $userName 선생님',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
