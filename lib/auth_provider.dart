import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  String? _authToken;

  String? get authToken => _authToken;

  void setAuthToken(String? token) {
    _authToken = token;
    notifyListeners();
  }
}
