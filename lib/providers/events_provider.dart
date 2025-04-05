import 'package:flutter/material.dart';
import 'package:campus_app/models/event.dart';
import 'package:campus_app/services/api_service.dart';

class EventsProvider with ChangeNotifier {
  List<Event> _upcomingEvents = [];
  List<Event> _allEvents = [];
  List<Event> _todayEvents = [];

  List<Event> get upcomingEvents => _upcomingEvents;
  List<Event> get allEvents => _allEvents;
  List<Event> get todayEvents => _todayEvents;

  Future<void> fetchUpcomingEvents() async {
    try {
      final eventsData = await ApiService.getUpcomingEvents();
      _upcomingEvents = eventsData.map((data) => Event.fromJson(data)).toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAllEvents() async {
    try {
      final eventsData = await ApiService.getAllEvents();
      _allEvents = eventsData.map((data) => Event.fromJson(data)).toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchTodayEvents() async {
    try {
      final eventsData = await ApiService.getTodayEvents();
      _todayEvents = eventsData.map((data) => Event.fromJson(data)).toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> registerForEvent(String eventId) async {
    try {
      await ApiService.registerForEvent(eventId);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

