
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'services/auth_service.dart';
import 'views/login_view.dart';
import 'views/character_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('favorites');

  final isLoggedIn = await AuthService.isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Harry Potter App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFFFF7FC),
      ),
      home: isLoggedIn
          ? const CharacterView()
          : const LoginView(),
    );
  }
}
