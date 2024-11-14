class NotificationItem {
  final int id;
  final String type;
  final String time;
  final bool read;

  NotificationItem({
    required this.id,
    required this.type,
    required this.time,
    required this.read,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['notificationId'],
      type: json['type'],
      time: json['time'],
      read: json['read'],
    );
  }
}
