class NoticeItem {
  final String title;
  final DateTime date;
  final bool isNew;

  NoticeItem({
    required this.title,
    required this.date,
    this.isNew = false,
  });
}
