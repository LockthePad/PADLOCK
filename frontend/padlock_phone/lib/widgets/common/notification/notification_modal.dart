import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:padlock_phone/apis/common/notification_service_api.dart';
import 'package:padlock_phone/model/common/notification_item.dart';
import 'package:padlock_phone/theme/colors.dart';

class NotificationModal extends StatefulWidget {
  final List<NotificationItem> notifications;
  final NotificationServiceApi notificationService;
  final VoidCallback onNotificationsRead;

  const NotificationModal({
    Key? key,
    required this.notifications,
    required this.notificationService,
    required this.onNotificationsRead,
  }) : super(key: key);

  @override
  State<NotificationModal> createState() => _NotificationModalState();
}

class _NotificationModalState extends State<NotificationModal> {
  List<NotificationItem> _unreadNotifications = [];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    _unreadNotifications = widget.notifications
        .where((notification) => !notification.read)
        .toList()
      ..sort(
          (a, b) => _parseDateTime(b.time).compareTo(_parseDateTime(a.time)));
  }

  String _getNotificationMessage(String type) {
    switch (type) {
      case 'ATTENDANCE':
        return '출석 관련 변경사항이 있습니다.';
      case 'NOTICE':
        return '공지사항이 등록되었습니다.';
      case 'SUGGESTION':
        return '건의사항이 등록되었습니다.';
      case 'COUNSELING':
        return '상담이 신청되었습니다.';
      default:
        return '새로운 알림이 있습니다.';
    }
  }

  Icon _getNotificationIcon(String type) {
    switch (type) {
      case 'ATTENDANCE':
        return const Icon(Icons.calendar_today, color: AppColors.yellow);
      case 'NOTICE':
        return const Icon(Icons.announcement, color: AppColors.yellow);
      case 'SUGGESTION':
        return const Icon(Icons.lightbulb, color: AppColors.yellow);
      case 'COUNSELING':
        return const Icon(Icons.chat, color: AppColors.yellow);
      default:
        return const Icon(Icons.notifications, color: AppColors.yellow);
    }
  }

  Future<void> _markAsRead(int notificationId) async {
    try {
      await widget.notificationService.markAsRead(notificationId);

      setState(() {
        _unreadNotifications
            .removeWhere((notification) => notification.id == notificationId);
      });

      widget.onNotificationsRead();

      if (_unreadNotifications.isEmpty && mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error marking notification as read: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('알림 읽음 처리 중 오류가 발생했습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      for (var notification in _unreadNotifications) {
        await widget.notificationService.markAsRead(notification.id);
      }
      widget.onNotificationsRead();

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error marking notifications as read: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('알림 읽음 처리 중 오류가 발생했습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  DateTime _parseDateTime(String dateTimeString) {
    try {
      final DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm');
      return formatter.parse(dateTimeString);
    } catch (e) {
      print('Error parsing date: $e');
      return DateTime.now();
    }
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = _parseDateTime(dateTimeString);
      return DateFormat('MM/dd HH:mm').format(dateTime);
    } catch (e) {
      print('Error formatting date: $e');
      return dateTimeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 400,
        height: 600,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '알림',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 20),
            Expanded(
              child: _unreadNotifications.isEmpty
                  ? const Center(
                      child: Text(
                        '읽지 않은 알림이 없습니다',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _unreadNotifications.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final notification = _unreadNotifications[index];
                        return InkWell(
                          onTap: () => _markAsRead(notification.id),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: _getNotificationIcon(notification.type),
                            title: Text(
                              _getNotificationMessage(notification.type),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              _formatDateTime(notification.time),
                              style: const TextStyle(
                                color: AppColors.grey,
                                fontSize: 14,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.check_circle_outline,
                              color: AppColors.grey,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (_unreadNotifications.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _markAllAsRead,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '모두 읽음 처리',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
