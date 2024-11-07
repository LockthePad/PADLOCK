import 'package:flutter/material.dart';
import 'package:padlock_tablet/theme/colors.dart';

class NoteDetailModal extends StatelessWidget {
  final String content;
  final String timestamp;

  const NoteDetailModal({
    super.key,
    required this.content,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.8,
        padding:
            const EdgeInsets.only(left: 36, right: 24, top: 24, bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 60),
                        const Text(
                          "필기 상세보기",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 10,
                      width: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.yellow,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 235,
                  top: 0,
                  child: Image(
                    image: const AssetImage('assets/pencil.png'),
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: -12,
                  top: -12,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.yellow,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.yellow,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            timestamp,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.yellow,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            content,
                            style: const TextStyle(
                              fontSize: 20,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
