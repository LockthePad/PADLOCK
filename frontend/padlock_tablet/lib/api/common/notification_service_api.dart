// notification_service_api.dart
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

  Stream<List<NotificationItem>> get notificationStream =>
      _notificationController.stream;

  Future<List<NotificationItem>> getNotifications() async {
    try {
      final token = await storage.read(key: 'accessToken');
      final response = await http.get(
        Uri.parse('$apiServerUrl/notifications'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((item) => NotificationItem.fromJson(item)).toList();
      }
      throw Exception('Failed to load notifications');
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  Future<void> subscribeToNotifications() async {
    if (_isConnected) return;

    try {
      final token = await storage.read(key: 'accessToken');

      // 이전 연결 정리
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
      final stream = response.stream.transform(utf8.decoder);

      String buffer = '';

      _sseSubscription = stream.listen(
        (data) {
          buffer += data;

          // 완전한 SSE 메시지들을 처리
          while (buffer.contains('\n\n')) {
            final index = buffer.indexOf('\n\n');
            final message = buffer.substring(0, index);
            buffer = buffer.substring(index + 2);

            _handleSSEMessage(message);
          }
        },
        onError: (error) {
          print('SSE error: $error');
          _scheduleReconnection();
        },
        onDone: () {
          print('SSE connection closed');
          _scheduleReconnection();
        },
        cancelOnError: false,
      );

      _isConnected = true;
      print('SSE connection established');
    } catch (e) {
      print('Error in SSE subscription: $e');
      _scheduleReconnection();
    }
  }

  void _handleSSEMessage(String message) {
    try {
      // SSE 메시지 파싱
      final lines = message.split('\n');
      for (final line in lines) {
        if (line.startsWith('data:')) {
          final jsonData = line.substring(5).trim(); // 'data:' 이후의 JSON 데이터
          try {
            final parsed = json.decode(jsonData);
            if (parsed is List) {
              final notifications = parsed
                  .map((item) => NotificationItem.fromJson(item))
                  .toList();
              _notificationController.add(notifications);
              print('Received notifications: ${notifications.length}');
            }
          } catch (e) {
            print('Error parsing JSON data: $e');
          }
        }
      }
    } catch (e) {
      print('Error handling SSE message: $e');
    }
  }

  void _scheduleReconnection() {
    _isConnected = false;
    _cleanup();
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      print('Attempting to reconnect to SSE...');
      subscribeToNotifications();
    });
  }

  Future<void> _cleanup() async {
    _isConnected = false;
    await _sseSubscription?.cancel();
    _client?.close();
    _client = null;
    _sseSubscription = null;
  }

  void dispose() {
    _cleanup();
    _reconnectTimer?.cancel();
    _notificationController.close();
  }

  Future<bool> markAsRead(int notificationId) async {
    try {
      final token = await storage.read(key: 'accessToken');
      final response = await http.post(
        Uri.parse('$apiServerUrl/notifications/$notificationId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }
}
