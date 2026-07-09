import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:respilink_app/core/constants/app_constants.dart';
import 'package:respilink_app/injections.dart';
import 'package:respilink_app/providers.dart';
import 'package:respilink_app/routes/router_configuration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();

  // Preload token before widgets build so the API interceptor has it
  // immediately when GoRouter restores a dashboard route.
  const storage = FlutterSecureStorage();
  final cachedToken = await storage.read(key: 'auth_token');
  if (cachedToken != null && cachedToken.isNotEmpty) {
    AppConstants.apiToken = cachedToken;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: Providers.getProviders(context),
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        routerConfig: RouterConfiguration.router,
      ),
    );
  }
}
