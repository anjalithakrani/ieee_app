import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/providers/auth_provider.dart';
import 'package:campus_app/providers/events_provider.dart';
import 'package:campus_app/providers/feed_provider.dart';
import 'package:campus_app/providers/clubs_provider.dart';
import 'package:campus_app/splash_screen.dart';
import 'package:campus_app/utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EventsProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        ChangeNotifierProvider(create: (_) => ClubsProvider()),
      ],
      child: MaterialApp(
        title: 'Campus App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: SplashScreen(), // SplashScreen will not have AppBar
      ),
    );
  }
}

// Common AppBar for all screens except SplashScreen
class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/ieee_logo.png', // Ensure this path is correct
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'IEEE VESIT',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: child,
    );
  }
}
