import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:respilink_mobile/app.dart';
import 'package:respilink_mobile/exports.dart';
import 'package:respilink_mobile/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  initDependencies();

  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //await NotificationService.initialize();

  SystemChrome.setPreferredOrientations([.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );
  runApp( MyApp());
}
