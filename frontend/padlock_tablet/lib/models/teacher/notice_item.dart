class NoticeItem {
  final int noticeId;
  final String title;
  final String content;
  final DateTime createdAt;

  NoticeItem({
    required this.noticeId,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory NoticeItem.fromJson(Map<String, dynamic> json) {
    // 날짜 형식 맞추기
    final dateString = json['createdAt'] as String;
    final parsedDate = _parseDate(dateString);

    return NoticeItem(
      noticeId: json['noticeId'],
      title: json['title'],
      content: json['content'],
      createdAt: parsedDate,
    );
  }

  // 날짜 문자열을 DateTime 객체로 변환하는 함수
  static DateTime _parseDate(String dateString) {
    final parts = dateString.split(' ');
    final datePart = parts[0].split('.');
    final timePart = parts[1].split(':');

    return DateTime(
      int.parse(datePart[0]), // year
      int.parse(datePart[1]), // month
      int.parse(datePart[2]), // day
      int.parse(timePart[0]), // hour
      int.parse(timePart[1]), // minute
    );
  }
}
