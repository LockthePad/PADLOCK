import 'package:flutter/material.dart';
import 'package:padlock_tablet/api/teacher/suggestion_api.dart';
import 'package:padlock_tablet/models/teacher/suggestion_item.dart';
import 'package:padlock_tablet/widgets/teacher/mainScreen/title_widget.dart';
import 'package:padlock_tablet/widgets/teacher/suggestionWidget/suggestion_card.dart';

class TeaSuggestionWidget extends StatefulWidget {
  const TeaSuggestionWidget({super.key});

  @override
  _TeaSuggestionWidgetState createState() => _TeaSuggestionWidgetState();
}

class _TeaSuggestionWidgetState extends State<TeaSuggestionWidget> {
  List<SuggestionItem> suggestions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSuggestions();
  }

  Future<void> _fetchSuggestions() async {
    try {
      final fetchedSuggestions = await SuggestionApi.fetchSuggestions();
      setState(() {
        suggestions = fetchedSuggestions;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching suggestions: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _markAsRead(int suggestionId) async {
    try {
      await SuggestionApi.markAsRead(suggestionId);
      setState(() {
        // 읽음 처리된 항목의 상태를 업데이트
        suggestions = suggestions.map((suggestion) {
          if (suggestion.suggestionId == suggestionId) {
            return SuggestionItem(
              suggestionId: suggestion.suggestionId,
              content: suggestion.content,
              time: suggestion.time,
              studentName: suggestion.studentName,
              read: true, // 읽음 상태로 변경
            );
          }
          return suggestion;
        }).toList();
      });
    } catch (e) {
      print("Error marking suggestion as read: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleWidget(title: '건의함 보기'),
          const SizedBox(height: 10),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.8,
                ),
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return SuggestionCard(
                    suggestionId: suggestion.suggestionId,
                    content: suggestion.content,
                    timestamp: suggestion.time,
                    author: suggestion.studentName,
                    isRead: suggestion.read,
                    onReadUpdate:
                        _fetchSuggestions, // 읽음 처리 후 UI 업데이트를 위해 _fetchSuggestions 사용
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
