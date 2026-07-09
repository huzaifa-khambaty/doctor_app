import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:respilink_mobile/core/constants/pusher_events.dart';
import 'package:respilink_mobile/core/network/api_endpoints.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:respilink_mobile/exports.dart';

class PusherService {
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  final _eventStreamController = StreamController<PusherEvent>.broadcast();
  Stream<PusherEvent> get eventStream => _eventStreamController.stream;

  bool _isConnected = false;
  final List<String> _pendingChannels = [];
  final Set<String> _subscribedChannels = {}; // 👈 track active subscriptions

  Future<void> initPusher() async {
    try {
      await pusher.init(
        apiKey: PusherEvents.apiKey,
        cluster: PusherEvents.cluster,
        useTLS: true,
        activityTimeout: 30000,
        pongTimeout: 10000,
        onAuthorizer: (channelName, socketId, options) async {
          try {

            debugPrint("Cluster: ${PusherEvents.cluster}");
            final dio = Dio();
            final response = await dio.post(
              '${ApiEndpoints.baseUrl}/broadcasting/auth',
              data: 'channel_name=$channelName&socket_id=$socketId',
              options: Options(
                contentType: 'application/x-www-form-urlencoded',
                headers: {
                  'Authorization': 'Bearer ${AppConstants.apiToken}',
                  'Accept': 'application/json',
                },
                responseType: ResponseType.plain,
                validateStatus: (status) => true,
              ),
            );

            final data = response.data is String
                ? jsonDecode(response.data as String) as Map<String, dynamic>
                : response.data as Map<String, dynamic>;

            return data;
          } catch (e) {
            debugPrint('Pusher Authorizer Error: $e');
            return {};
          }
        },
        onEvent: (PusherEvent event) {
          print("Pusher Event Received: ${event.eventName} on ${event.channelName}");
          _eventStreamController.add(event);
        },
        onConnectionStateChange: (currentState, previousState) async {
          print("Pusher Connection State: $previousState → $currentState");

          if (currentState == 'CONNECTED') {
            _isConnected = true;

            // 👇 resubscribe previously subscribed channels on reconnect
            final toResubscribe = Set<String>.from(_subscribedChannels);
            _subscribedChannels.clear(); // clear so _doSubscribe can re-add them

            for (final channel in toResubscribe) {
              await _doSubscribe(channel);
            }

            // 👇 also flush pending channels
            for (final channel in List.from(_pendingChannels)) {
              if (!_subscribedChannels.contains(channel)) {
                await _doSubscribe(channel);
              }
            }
            _pendingChannels.clear();

          } else if (currentState == 'DISCONNECTED') {
            _isConnected = false;
            debugPrint("PUSHER: Disconnected — retrying in 5 seconds...");
            await Future.delayed(const Duration(seconds: 5));
            await _reconnect();

          } else {
            _isConnected = false;
          }
        },
        onError: (message, code, error) {
          debugPrint("Pusher Error: $message (Code: $code)");
        },
      );

      await pusher.connect();
    } catch (e) {
      debugPrint("Pusher Initialization Error: $e");
    }
  }

  Future<void> _reconnect() async {
    try {
      debugPrint("PUSHER: Attempting reconnect...");
      await pusher.connect();
    } catch (e) {
      debugPrint("PUSHER: Reconnect error: $e");
    }
  }

  Future<void> _doSubscribe(String channelName) async {
    try {
      // 👇 skip if already subscribed
      if (_subscribedChannels.contains(channelName)) {
        debugPrint("Already subscribed to: $channelName, skipping...");
        return;
      }
      await pusher.subscribe(channelName: channelName);
      _subscribedChannels.add(channelName); // 👈 track it
      debugPrint("Subscribed to: $channelName");
    } catch (e) {
      debugPrint("Subscription Error: $e");
    }
  }

  Future<void> subscribeToChannel(String channelName) async {
    if (_isConnected) {
      await _doSubscribe(channelName);
    } else {
      debugPrint("Pusher not connected yet, queuing: $channelName");
      if (!_pendingChannels.contains(channelName)) {
        _pendingChannels.add(channelName);
      }
    }
  }

  Future<void> unsubscribe(String channelName) async {
    try {
      _pendingChannels.remove(channelName);
      _subscribedChannels.remove(channelName); // 👈 remove from tracking
      await pusher.unsubscribe(channelName: channelName);
      debugPrint("Unsubscribed from: $channelName");
    } catch (e) {
      debugPrint("Unsubscribe Error: $e");
    }
  }

  Future<void> disconnect() async {
    _isConnected = false;
    _pendingChannels.clear();
    _subscribedChannels.clear(); // 👈 clear tracking
    await pusher.disconnect();
  }
}