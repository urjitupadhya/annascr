import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
    ),
    home: ProfileScreen(),
  ));
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> profileData = {};
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      final accessToken = await TokenStorage.getToken(storage);

      if (accessToken != null) {
        final response = await http.get(
          Uri.parse('http://192.168.29.71:8000/api/profile'),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        );

        print('API Response Code: ${response.statusCode}'); // Debug statement

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          setState(() {
            profileData = responseData;
          });
        } else {
          print('API Error: ${response.body}');
        }
      } else {
        print('No access token found.');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: const Color.fromARGB(255, 145, 145, 145),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: Image.asset(
                'assets/images/profile.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 80,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Qualification: ${profileData["qualification"]}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Stream: ${profileData["stream"]}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Phone: ${profileData["phone"]}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Role: ${profileData["role"]}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Created At: ${profileData["created_at"]}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Updated At: ${profileData["updated_at"]}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Add functionality to edit profile
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                    ),
                    child: Text('Edit Profile'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TokenStorage {
  static const String _tokenKey = 'auth_token';

  static Future<void> saveToken(String accessToken, FlutterSecureStorage storage) async {
    await storage.write(key: _tokenKey, value: accessToken);
  }

  static Future<String?> getToken(FlutterSecureStorage storage) async {
    return await storage.read(key: _tokenKey);
  }
}
