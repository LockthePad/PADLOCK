class TimetableItem {
  final int scheduleId;
  final String day;
  final int period;
  final String subject;

  TimetableItem({
    required this.scheduleId,
    required this.day,
    required this.period,
    required this.subject,
  });

  factory TimetableItem.fromJson(Map<String, dynamic> json) {
    return TimetableItem(
      scheduleId: json['scheduleId'],
      day: json['day'],
      period: json['period'],
      subject: json['subject'],
    );
  }
}
