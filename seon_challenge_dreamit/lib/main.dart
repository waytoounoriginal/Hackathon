import 'package:flutter/material.dart';

import './pages/main_page.dart';
import './pages/dashboard.dart';
import './pages/account_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Raleway',
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/dashboard': (context) => const Dashboard(),
        '/account_view': (context) => const AccountViewer(),
      },
      home: const MainPage(),
    );
  }
}
