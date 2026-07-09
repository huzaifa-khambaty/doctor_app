import 'package:flutter/services.dart';
import 'package:respilink_mobile/app.dart';
import 'package:respilink_mobile/exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
