import 'package:cipher/core/router/app_router.dart';
import 'package:cipher/core/theme/app_theme.dart';
import 'package:cipher/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // 1. Immediate Binding
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Non-blocking System UI logic - makes the app look themed instantly
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF080810),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // 3. Open Hive early so splash screen can read name
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.hiveSettingsBox);
  await Hive.openBox(AppConstants.hiveHistoryBox);

  // 4. Run App immediately. 
  // Firebase is handled by initializationProvider during the splash screen.
  runApp(
    const ProviderScope(
      child: CipherApp(),
    ),
  );
}

class CipherApp extends ConsumerWidget {
  const CipherApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
