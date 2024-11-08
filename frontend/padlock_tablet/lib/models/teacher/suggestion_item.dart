class SuggestionItem {
  final int suggestionId;
  final String studentName;
  final String content;
  final String time;
  final bool read;

  SuggestionItem({
    required this.suggestionId,
    required this.studentName,
    required this.content,
    required this.time,
    required this.read,
  });

  // JSON 데이터를 SuggestionItem 객체로 변환하는 함수
  factory SuggestionItem.fromJson(Map<String, dynamic> json) {
    return SuggestionItem(
      suggestionId: json['suggestionId'],
      studentName: json['studentName'],
      content: json['content'],
      time: json['time'],
      read: json['read'],
    );
  }

  // SuggestionItem 객체를 JSON으로 변환하는 함수 (필요한 경우)
  Map<String, dynamic> toJson() {
    return {
      'suggestionId': suggestionId,
      'studentName': studentName,
      'content': content,
      'time': time,
      'read': read,
    };
  }
}
