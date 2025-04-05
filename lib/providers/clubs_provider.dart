import 'package:flutter/material.dart';
import 'package:campus_app/models/club.dart';
import 'package:campus_app/services/api_service.dart';

class ClubsProvider with ChangeNotifier {
  List<Club> _clubs = [];
  List<Club> _userClubs = [];

  List<Club> get clubs => _clubs;
  List<Club> get userClubs => _userClubs;

  Future<void> fetchClubs() async {
    try {
      final clubsData = await ApiService.getClubs();
      _clubs = clubsData.map((data) => Club.fromJson(data)).toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchUserClubs() async {
    try {
      final clubsData = await ApiService.getUserClubs();
      _userClubs = clubsData.map((data) => Club.fromJson(data)).toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> saveUserClubs(List<Club> selectedClubs) async {
    try {
      final clubIds = selectedClubs.map((club) => club.id).toList();
      await ApiService.saveUserClubs(clubIds);
      _userClubs = selectedClubs;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> joinClub(String clubId) async {
    try {
      await ApiService.joinClub(clubId);
      
      // Update local state
      final club = _clubs.firstWhere((club) => club.id == clubId);
      if (!_userClubs.contains(club)) {
        _userClubs.add(club);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> leaveClub(String clubId) async {
    try {
      await ApiService.leaveClub(clubId);
      
      // Update local state
      _userClubs.removeWhere((club) => club.id == clubId);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

