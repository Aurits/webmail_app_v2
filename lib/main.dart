import 'package:flutter/material.dart';
import 'package:makerere_webmail_app/pages/emails/emails.dart';
import 'package:makerere_webmail_app/pages/onboarding/landing_page.dart';
import 'package:makerere_webmail_app/pages/onboarding/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'webmail app',
        home: const LandingPage(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/emails': (context) => const EmailsPage(),
        });
  }
}
