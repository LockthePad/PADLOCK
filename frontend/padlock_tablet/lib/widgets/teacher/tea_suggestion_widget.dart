import 'package:flutter/material.dart';
import 'package:padlock_tablet/widgets/teacher/mainScreen/title_widget.dart';
import 'package:padlock_tablet/widgets/teacher/suggestionWidget/suggestion_card.dart';

class TeaSuggestionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> suggestions;

  const TeaSuggestionWidget({
    super.key,
    required this.suggestions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 타이틀
          const TitleWidget(title: '건의함 보기'),
          const SizedBox(height: 10),
          // 건의함 카드 그리드
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 한 행에 3개의 카드
                crossAxisSpacing: 10, // 카드 사이의 가로 간격
                mainAxisSpacing: 10, // 카드 사이의 세로 간격
                childAspectRatio: 1.8, // 카드의 가로 세로 비율
              ),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return SuggestionCard(
                  content: suggestion['content'],
                  timestamp: suggestion['timestamp'],
                  author: suggestion['author'],
                  isRead: suggestion['isRead'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
