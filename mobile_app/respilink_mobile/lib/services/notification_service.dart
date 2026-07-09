import 'dart:ui';

import 'package:respilink_mobile/exports.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

// ✅ Must be a top-level function for background handling
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.ensureInitialized();

  debugPrint("Background message: ${message.data}");
  final title =
      message.notification?.title ?? message.data['title']?.toString() ?? '';
  final body =
      message.notification?.body ?? message.data['body']?.toString() ?? '';
  final imageUrl =
      message.notification?.android?.imageUrl ??
      message.notification?.apple?.imageUrl ??
      message.data['imageUrl']?.toString() ??
      message.data['image_url']?.toString();

  if (title.isNotEmpty || body.isNotEmpty) {
    await NotificationService.showLocalNotification(
      title: title,
      body: body,
      imageUrl: imageUrl,
    );
  }
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    // ✅ Register background handler FIRST
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

    // 1. Request Permissions
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(alert: true, badge: true, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else {
      debugPrint('Permission denied: ${settings.authorizationStatus}');
      return; // Exit early — no point continuing
    }

    // 2. Initialize Local Notifications
    await ensureInitialized();

    // 3. Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Foreground message: ${message.data}");
      if (message.notification != null) {
        showLocalNotification(
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
          imageUrl:
              message.notification!.android?.imageUrl ??
              message.notification!.apple?.imageUrl,
        );
      }
    });

    // ✅ 4. App opened from a notification (background → foreground)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notification tapped (from background): ${message.data}");
      //locator<NavigationService>().navigateAndRemove(RouterStrings.mainView);
    });

    // ✅ 5. App launched from terminated state via notification
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      debugPrint(
        "App launched from terminated via notification: ${initialMessage.data}",
      );
      // Navigate or handle tap here
    }

    // ✅ Always log the token so you can verify Firebase is working
    await getToken();
  }

  static Future<void> ensureInitialized() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@drawable/ic_notification',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(settings: initSettings);
    _isInitialized = true;
  }

  static Future<void> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) AppConstants.firebaseToken = token;
    debugPrint("FCM Token: $token");
  }

  static Future<String?> _downloadAndSaveFile(
    String url,
    String fileName,
  ) async {
    final Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      await dio.download(url, filePath, deleteOnError: true);
      return filePath;
    } on DioException catch (e) {
      debugPrint('Image download error: ${e.type}');
      return null;
    } catch (e) {
      debugPrint('Image download unknown error: $e');
      return null;
    }
  }

  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? imageUrl,
  }) async {
    await ensureInitialized();
    BigPictureStyleInformation? bigPictureStyle;

    // ✅ Reuse downloaded paths instead of downloading 3 times
    String? largeIconPath;
    String? bigPicturePath;
    String? iosImagePath;

    if (imageUrl != null) {
      largeIconPath = await _downloadAndSaveFile(imageUrl, 'largeIcon');
      bigPicturePath = await _downloadAndSaveFile(imageUrl, 'bigPicture');
      iosImagePath = await _downloadAndSaveFile(
        imageUrl,
        'notification_img.jpg',
      );

      if (largeIconPath != null && bigPicturePath != null) {
        bigPictureStyle = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          largeIcon: FilePathAndroidBitmap(largeIconPath),
          contentTitle: title,
          summaryText: body,
        );
      }
    }

    final androidDetails = AndroidNotificationDetails(
      'fayzehusayni',
      'fayzehusayni Notifications',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigPictureStyle,
      icon: '@drawable/ic_notification',
    );

    // ✅ Safe: only attach image if download succeeded
    final iosDetails = DarwinNotificationDetails(
      attachments: iosImagePath != null
          ? [DarwinNotificationAttachment(iosImagePath)]
          : [],
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: DateTime.now().millisecond,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }
}
