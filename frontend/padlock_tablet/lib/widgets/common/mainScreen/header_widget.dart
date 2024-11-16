// header_widget.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:padlock_tablet/api/common/notification_service_api.dart';
import 'package:padlock_tablet/theme/colors.dart';
import 'package:padlock_tablet/widgets/common/mainScreen/notification_modal.dart';
import 'package:padlock_tablet/models/common/notification_item.dart';

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
  bool _hasUnreadNotifications = false;
  StreamSubscription? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    print('HeaderWidget initialized');
    _initializeNotifications();
  }

  @override
  void dispose() {
    print('HeaderWidget disposing');
    _notificationSubscription?.cancel();
    _notificationService.dispose();
    super.dispose();
  }

  Future<void> _initializeNotifications() async {
    print('Initializing notifications in HeaderWidget');

    // 초기 알림 상태 설정
    try {
      final initialNotifications =
          await _notificationService.getNotifications();
      if (mounted) {
        setState(() {
          _notifications = initialNotifications;
          _updateUnreadStatus();
        });
      }
    } catch (e) {
      print('Error loading initial notifications: $e');
    }

    // 스트림 구독
    _notificationSubscription = _notificationService.notificationStream.listen(
      (notifications) {
        print(
            'Received notification update in HeaderWidget: ${notifications.length} notifications');
        if (mounted) {
          setState(() {
            _notifications = notifications;
            _updateUnreadStatus();
          });
        }
      },
      onError: (error) {
        print('Error in notification stream: $error');
      },
      onDone: () {
        print('Notification stream closed');
      },
    );

    // SSE 구독 시작
    await _notificationService.subscribeToNotifications();
  }

  void _updateUnreadStatus() {
    final hasUnread = _notifications.any((notification) => !notification.read);
    print('Updating unread status: $hasUnread');
    if (_hasUnreadNotifications != hasUnread) {
      setState(() {
        _hasUnreadNotifications = hasUnread;
        print('Notification icon status updated: $_hasUnreadNotifications');
      });
    }
  }

  Future<void> _handleNotificationsRead() async {
    setState(() {
      _notifications = _notificationService.currentNotifications;
      _updateUnreadStatus();
    });
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
        return AppColors.yellow;
      case 'ABSENT':
        return AppColors.errorRed;
      default:
        return AppColors.grey;
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
