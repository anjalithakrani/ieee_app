import 'package:flutter/material.dart';
import 'package:campus_app/models/user.dart';
import 'package:campus_app/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  String? _token;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;

  Future<void> login(String email, String password, UserType userType) async {
    try {
      final response = await ApiService.login(email, password, userType);
      _token = response['token'];
      _currentUser = User.fromJson(response['user']);
      _isAuthenticated = true;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> register(String email, String password, UserType userType) async {
    try {
      final response = await ApiService.register(email, password, userType);
      _token = response['token'];
      _currentUser = User.fromJson(response['user']);
      _isAuthenticated = true;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    _isAuthenticated = false;
    _token = null;
    notifyListeners();
  }

  Future<void> getUserProfile() async {
    try {
      if (_token == null) return;
      
      final userData = await ApiService.getUserProfile(_token!);
      _currentUser = User.fromJson(userData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> userData) async {
    try {
      if (_token == null || _currentUser == null) return;
      
      final updatedUserData = await ApiService.updateUserProfile(_token!, userData);
      _currentUser = User.fromJson(updatedUserData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

