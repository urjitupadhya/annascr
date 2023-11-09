import 'package:flutter/material.dart';
import 'package:login_page/onboarding_screen.dart';
import 'package:login_page/registration_screen.dart';
import 'package:login_page/widgets/gradient_button.dart';
import 'package:login_page/widgets/login_field.dart';
import 'package:login_page/widgets/social_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CAREERAPP',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
Future<void> loginUser(String email, String password, BuildContext context) async {
  final url = Uri.parse('http://192.168.29.71:8000/api/login');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final Map<String, dynamic> data = json.decode(response.body);

    if (response.statusCode == 200 && data.containsKey('access_token')) {
      String accessToken = data['access_token'];
      String tokenType = data['token_type'];
      int expiresIn = data['expires_in'];

      await TokenStorage.saveToken(accessToken, tokenType, expiresIn);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OnboardingScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. ${data["error"] ?? "Unknown error"}'),
          duration: Duration(seconds: 3),
        ),
      );
      print('Login failed. ${data["error"] ?? "Unknown error"}');
    }
  } catch (error) {
    print('Error: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to login. Please try again. Check logs for details.'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}


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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'CAREER FINDER',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                SocialButton(
                  onPressed: () async {
                    // Implement social login logic here
                  },
                  label: ' Continue with Google  ',
                  iconPath: 'assets/svg/google.svg',
                  horizontalPadding: 20,
                ),
                const SizedBox(height: 10),
                const Text(
                  'or',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 15),
                const LoginField(hintText: 'Email'),
                const SizedBox(height: 15),
                const LoginField(hintText: 'Password'),
                const SizedBox(height: 20),
                const GradientButton(),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    loginUser('user@example.com', 'password', context);
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TokenStorage {
  static const String _tokenKey = 'access_token';
  static const String _tokenTypeKey = 'token_type';
  static const String _expiresInKey = 'expires_in';

  static Future<void> saveToken(
      String accessToken, String tokenType, int expiresIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_tokenKey, accessToken);
    prefs.setString(_tokenTypeKey, tokenType);
    prefs.setInt(_expiresInKey, expiresIn);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}
