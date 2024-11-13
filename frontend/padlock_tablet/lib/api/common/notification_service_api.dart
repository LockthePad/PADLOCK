import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:padlock_tablet/models/common/notification_item.dart';

class NotificationServiceApi {
  static String apiServerUrl = dotenv.get("API_SERVER_URL");
  final storage = const FlutterSecureStorage();
  Timer? _reconnectTimer;
  final _notificationController =
      StreamController<List<NotificationItem>>.broadcast();
  http.Client? _client;
  StreamSubscription? _sseSubscription;
  bool _isConnected = false;
  List<NotificationItem> _currentNotifications = [];

  Stream<List<NotificationItem>> get notificationStream =>
      _notificationController.stream;
  List<NotificationItem> get currentNotifications => _currentNotifications;

  Future<List<NotificationItem>> getNotifications() async {
    try {
      final token = await storage.read(key: 'accessToken');
      print('Fetching notifications with token: ${token?.substring(0, 10)}...');

      final response = await http.get(
        Uri.parse('$apiServerUrl/notifications'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Notifications response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        _currentNotifications =
            data.map((item) => NotificationItem.fromJson(item)).toList();
        print('Fetched ${_currentNotifications.length} notifications');
        _notificationController.add(_currentNotifications); // 스트림에 새 알림 추가
        return _currentNotifications;
      }
      throw Exception('Failed to load notifications: ${response.statusCode}');
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  Future<void> subscribeToNotifications() async {
    if (_isConnected) {
      print('Already connected to SSE');
      return;
    }

    try {
      print('Starting SSE subscription...');
      await getNotifications(); // 초기 알림 로드

      final token = await storage.read(key: 'accessToken');
      await _cleanup();

      _client = http.Client();
      final request = http.Request('GET', Uri.parse('$apiServerUrl/subscribe'));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'Connection': 'keep-alive',
      });

      final response = await _client!.send(request);
      print('SSE response status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to establish SSE connection: ${response.statusCode}');
      }

      final stream = response.stream.transform(utf8.decoder);
      String buffer = '';

      _sseSubscription = stream.listen(
        (data) {
          print('Received SSE data: $data');
          buffer += data;

          while (buffer.contains('\n\n')) {
            final index = buffer.indexOf('\n\n');
            final message = buffer.substring(0, index);
            buffer = buffer.substring(index + 2);

            print('Processing SSE message: $message');

            // CONNECT 이벤트 처리
            if (message.contains('event:CONNECT')) {
              print('SSE Connection confirmed');
            }
            // 알림 이벤트 처리
            else if (message.contains('알림 전송')) {
              print('New notification received, fetching updates...');
              _fetchAndBroadcastNotifications();
            }
          }
        },
        onError: (error) {
          print('SSE error occurred: $error');
          _scheduleReconnection();
        },
        onDone: () {
          print('SSE connection closed by server');
          _scheduleReconnection();
        },
        cancelOnError: false,
      );

      _isConnected = true;
      print('SSE connection established successfully');
    } catch (e) {
      print('Error in SSE subscription: $e');
      _scheduleReconnection();
    }
  }

  Future<void> _fetchAndBroadcastNotifications() async {
    print('Fetching new notifications...');
    try {
      final notifications = await getNotifications();
      if (notifications.isNotEmpty) {
        print('Broadcasting ${notifications.length} notifications');
        _notificationController.add(notifications);

        // 읽지 않은 알림이 있는지 확인하고 로그 출력
        final unreadCount = notifications.where((n) => !n.read).length;
        print('Unread notifications count: $unreadCount');
      } else {
        print('No notifications to broadcast');
      }
    } catch (e) {
      print('Error fetching and broadcasting notifications: $e');
    }
  }

  void _scheduleReconnection() {
    print('Scheduling SSE reconnection...');
    _isConnected = false;
    _cleanup();
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      print('Attempting to reconnect to SSE...');
      subscribeToNotifications();
    });
  }

  Future<void> _cleanup() async {
    print('Cleaning up SSE connection...');
    _isConnected = false;
    await _sseSubscription?.cancel();
    _client?.close();
    _client = null;
    _sseSubscription = null;
  }

  Future<bool> markAsRead(int notificationId) async {
    try {
      final token = await storage.read(key: 'accessToken');
      print('Marking notification as read: $notificationId');

      final response = await http.post(
        Uri.parse('$apiServerUrl/notifications/$notificationId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Mark as read response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        await getNotifications();
        return true;
      }
      return false;
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }

  void dispose() {
    print('Disposing NotificationServiceApi');
    _cleanup();
    _reconnectTimer?.cancel();
    _notificationController.close();
  }
}
