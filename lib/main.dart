import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login_page/login_screen.dart';
import 'package:login_page/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CARRER FINDER',
      theme: ThemeData.dark(),
      home: FutureBuilder<bool>(
        future: shouldShowOnboarding(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return SplashScreen();
            } else {
              return BackgroundImageLoginScreen();
            }
          } else {
            return SplashScreen();
          }
        },
      ),
    );
  }

  Future<bool> shouldShowOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('showOnboarding') ?? true;
  }
}

class BackgroundImageLoginScreen extends StatelessWidget {
  const BackgroundImageLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/log.jpg',
            fit: BoxFit.cover,
          ),
          const LoginScreen(),
        ],
      ),
    );
  }
}
