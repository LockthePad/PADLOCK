import 'dart:async';
import 'package:flutter/material.dart';
import 'package:padlock_tablet/api/common/notification_service_api.dart';
import 'package:padlock_tablet/models/common/notification_item.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/common/mainScreen/notification_modal.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({
    super.key,
    required this.memberInfo,
    required this.isStudent,
    this.attendanceStatus = const {},
  });

  final String memberInfo;
  final bool isStudent;
  final Map<String, dynamic> attendanceStatus;

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  final NotificationServiceApi _notificationService = NotificationServiceApi();
  List<NotificationItem> _notifications = [];
  Timer? _pollingTimer;
  bool _hasUnreadNotifications = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeNotifications() async {
    await _fetchNotifications();
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    // 5초마다 알림 조회
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _fetchNotifications();
    });
  }

  Future<void> _fetchNotifications() async {
    try {
      final notifications = await _notificationService.getNotifications();
      if (mounted) {
        setState(() {
          // 새로운 알림이 있는지 확인
          final hasNewNotifications = notifications.any((newNotification) =>
              !_notifications
                  .any((existing) => existing.id == newNotification.id));

          if (hasNewNotifications) {
            _notifications = notifications;
            _updateUnreadStatus();
          }
        });
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  void _updateUnreadStatus() {
    final hasUnread = _notifications.any((notification) => !notification.read);
    if (_hasUnreadNotifications != hasUnread) {
      setState(() {
        _hasUnreadNotifications = hasUnread;
      });
    }
  }

  Future<void> _handleNotificationsRead() async {
    try {
      final updatedNotifications =
          await _notificationService.getNotifications();
      if (mounted) {
        setState(() {
          _notifications = updatedNotifications;
          _updateUnreadStatus();
        });
      }
    } catch (e) {
      print('Error refreshing notifications: $e');
    }
  }

  void _showNotificationModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => NotificationModal(
        notifications: _notifications,
        notificationService: _notificationService,
        onNotificationsRead: _handleNotificationsRead,
      ),
    );
  }

  Map<String, String> _parseMemberInfo() {
    print('Parsing memberInfo: ${widget.memberInfo}');

    if (widget.memberInfo.isEmpty) {
      return {
        'userClass': '로딩중...',
        'userName': '로딩중...',
      };
    }

    try {
      final parts = widget.memberInfo.split(' ');
      print('Split parts: $parts');

      if (parts.length >= 4) {
        final String name = parts.last;
        final String userClass = parts.take(parts.length - 1).join(' ');

        return {
          'userClass': userClass,
          'userName': name,
        };
      }
    } catch (e) {
      print('Error parsing memberInfo: $e');
    }

    return {
      'userClass': '정보 없음',
      'userName': '정보 없음',
    };
  }

  String _getStatusText() {
    if (!widget.isStudent) return '';

    if (widget.attendanceStatus['away'] == true) {
      return '자리비움';
    }

    switch (widget.attendanceStatus['status']) {
      case 'PRESENT':
        return '출석';
      case 'UNREPORTED':
        return '미체크';
      case 'LATE':
        return '지각';
      case 'ABSENT':
        return '결석';
      default:
        return '로딩중...';
    }
  }

  Color _getStatusColor() {
    if (!widget.isStudent) return AppColors.grey;

    if (widget.attendanceStatus['away'] == true) {
      return AppColors.paleYellow;
    }

    switch (widget.attendanceStatus['status']) {
      case 'PRESENT':
        return AppColors.successGreen;
      case 'UNREPORTED':
        return AppColors.grey;
      case 'LATE':
        return AppColors.paleYellow;
      case 'ABSENT':
        return AppColors.errorRed;
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String logoAsset =
        widget.isStudent ? 'assets/yellowLogo.png' : 'assets/navyLogo.png';

    final userInfo = _parseMemberInfo();

    return Container(
      padding: const EdgeInsets.only(right: 50, top: 30, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            logoAsset,
            height: 30,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: _hasUnreadNotifications
                          ? AppColors.yellow
                          : AppColors.grey,
                      size: 28,
                    ),
                    onPressed: _showNotificationModal,
                  ),
                  if (_hasUnreadNotifications)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.isStudent)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    widget.isStudent
                        ? '${userInfo['userClass']} ${userInfo['userName']}'
                        : '${userInfo['userClass']} ${userInfo['userName']} 선생님',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
