import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:login_page/registration_screen.dart';

void main() {
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
  Map<String, dynamic> profileData = {}; // Initialize an empty profile data map

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  // Function to fetch profile data from the API
  Future<void> fetchProfileData() async {
    try {
 final response = await http.get(
  Uri.parse('http://192.168.29.71:8000/api/profile'),
  headers: {
    'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
  },
);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          profileData = responseData;
        });
      } else {
        // Handle API error, e.g., display an error message
        print('API Error: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions here, e.g., connection issues
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
      body: Stack(
        children: [
          Image.asset(
            'assets/images/chatbot.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
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
                SizedBox(height: 20),
                ListTile(
                  title: Text('My Courses'),
                  leading: Icon(Icons.book),
                  onTap: () {
                    // Add functionality to navigate to the user's courses
                  },
                ),
                ListTile(
                  title: Text('Settings'),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    // Add functionality to navigate to the settings screen
                  },
                ),
                ListTile(
                  title: Text('Log Out'),
                  leading: Icon(Icons.exit_to_app),
                  onTap: () {
                    // Add functionality to log out the user
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Implement the "Skip" button functionality
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to the registration screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
