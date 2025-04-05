import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:campus_app/models/user.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  // Authentication
  static Future<Map<String, dynamic>> login(String email, String password, UserType userType) async {
    // For demo purposes, return mock data
    await Future.delayed(Duration(seconds: 1));
    
    return {
      'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        'id': '1',
        'name': userType == UserType.student ? 'Jonathan Smith' : 'Dr. Johnson',
        'email': email,
        'profileImage': null,
        'role': userType == UserType.student ? 'Student' : 'Teacher',
        'bio': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        'type': userType == UserType.student ? 'student' : 'teacher',
      }
    };
  }

  static Future<Map<String, dynamic>> register(String email, String password, UserType userType) async {
    // For demo purposes, return mock data
    await Future.delayed(Duration(seconds: 1));
    
    return {
      'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        'id': '1',
        'name': userType == UserType.student ? 'Jonathan Smith' : 'Dr. Johnson',
        'email': email,
        'profileImage': null,
        'role': userType == UserType.student ? 'Student' : 'Teacher',
        'bio': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        'type': userType == UserType.student ? 'student' : 'teacher',
      }
    };
  }

  static Future<Map<String, dynamic>> getUserProfile(String token) async {
    // For demo purposes, return mock data
    await Future.delayed(Duration(seconds: 1));
    
    return {
      'id': '1',
      'name': 'Jonathan Smith',
      'email': 'jonathan@example.com',
      'profileImage': null,
      'role': 'Student',
      'bio': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'type': 'student',
    };
  }

  static Future<Map<String, dynamic>> updateUserProfile(String token, Map<String, dynamic> userData) async {
    // For demo purposes, return mock data
    await Future.delayed(Duration(seconds: 1));
    
    return {
      'id': '1',
      'name': userData['name'] ?? 'Jonathan Smith',
      'email': userData['email'] ?? 'jonathan@example.com',
      'profileImage': userData['profileImage'],
      'role': 'Student',
      'bio': userData['bio'] ?? 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'type': 'student',
    };
  }

  // Events
  static Future<List<Map<String, dynamic>>> getUpcomingEvents() async {
    // For demo purposes, return mock data
    await Future.delayed(Duration(seconds: 1));
    
    return [
      {
        'id': '1',
        'name': 'Crack The Code',
        'date': '12 Feb 2023',
        'time': '10:00 AM',
        'location': 'Tapas Hall',
        'description': 'A coding competition for all students.',
        'imageUrl': null,
        'organizer': 'Coding Club',
      },
      {
        'id': '2',
        'name': 'Science Exhibition',
        'date': '15 Feb 2023',
        'time': '2:00 PM',
        'location': 'Main Auditorium',
        'description': 'Annual science exhibition showcasing student projects.',
        'imageUrl': null,
        'organizer': 'Science Club',
      },
    ];
  }

  static Future<List<Map<String, dynamic>>> getAllEvents() async {
    // For demo purposes, return mock data
    await Future.delayed(Duration(seconds: 1));
    
    return [
      {
        'id': '1',
        'name': 'Crack The Code',
        'date': '12 Feb 2023',
        'time': '10:00 AM',
        'location': 'Tapas Hall',
        'description': 'A coding competition for all students.',
        'imageUrl': null,
        'organizer': 'Coding Club',
      },
      {
        'id': '2',
        'name': 'Science Exhibition',
        'date': '15 Feb 2023',
        'time': '2:00 PM',
        'location': 'Main Auditorium',
        'description': 'Annual science exhibition showcasing student projects.',
        'imageUrl': null,
        'organizer': 'Science Club',
      },
      {
        'id': '3',
        'name': 'Assemble Geeks',
        'date': '20 Feb 2023',
        'time': '3:00 PM',
        'location': 'Room 101',
        'description': 'Weekly meeting of the tech enthusiasts.',
        'imageUrl': null,
        'organizer': 'Tech Club',
      },
      {
        'id': '4',
        'name': 'M\' Explore',
        'date': '25 Feb 2023',
        'time': '11:00 AM',
        'location': 'Tapas Hall',
        'description': 'Mathematics exploration event.',
        'imageUrl': null,
        'organizer': 'Math Club',
      },
    ];
  }

  static Future<List<Map<String, dynamic>>> getTodayEvents() async {
    // For demo purposes, return mock data
    await Future.delayed(Duration(seconds: 1));
    
    return [
      {
        'id': '3',
        'name': 'Assemble Geeks',
        'date': 'Today',
        'time': '3:00 PM',
        'location': 'Room 101',
        'description': 'Weekly meeting of the tech enthusiasts.',
        'imageUrl': null,
        'organizer': 'Tech Club',
      },
    ];
  }

  static Future<void> registerForEvent(String eventId) async {
    // For demo purposes, just delay
    await Future.delayed(Duration(seconds: 1));
  }

  // Posts
  static Future<List<Map<String, dynamic>>> getPosts() async {
    // For demo purposes, return mock data
    await Future.delayed(Duration(seconds: 1));
    
    return [
      {
        'id': '1',
        'authorId': '2',
        'authorName': 'Jonathan Smith',
        'authorImage': null,
        'content': 'Introducing the improvements in the upcoming sessions',
        'imageUrl': null,
        'likes': 15,
        'comments': 5,
        'timeAgo': '15 mins',
        'isLiked': false,
        'isSaved': false,
      },
      {
        'id': '2',
        'authorId': '3',
        'authorName': 'Tech Club',
        'authorImage': null,
        'content': 'Join us for the weekly tech meetup this Friday!',
        'imageUrl': null,
        'likes': 24,
        'comments': 8,
        'timeAgo': '2 hours',
        'isLiked': true,
        'isSaved': false,
      },
    ];
  }

  static Future<void> likePost(String postId) async {
    // For demo purposes, just delay
    await Future.delayed(Duration(seconds: 1));
  }

  static Future<void> savePost(String postId) async {
    // For demo purposes, just delay
    await Future.delayed(Duration(seconds: 1));
  }

  static Future<Map<String, dynamic>> createPost(String content, String? imageUrl) async {
    // For demo purposes, return mock data
    await Future.delayed(Duration(seconds: 1));
    
    return {
      'id': '${DateTime.now().millisecondsSinceEpoch}',
      'authorId': '1',
      'authorName': 'Jonathan Smith',
      'authorImage': null,
      'content': content,
      'imageUrl': imageUrl,
      'likes': 0,
      'comments': 0,
      'timeAgo': 'just now',
      'isLiked': false,
      'isSaved': false,
    };
  }

  // Clubs
  static Future<List<Map<String, dynamic>>> getClubs() async {
    // For demo purposes, return mock data
    await Future.delayed(Duration(seconds: 1));
    
    return [
      {
        'id': '1',
        'name': 'Coding Club',
        'description': 'For coding enthusiasts and developers',
        'type': 'Tech',
        'imageUrl': null,
        'memberCount': 45,
      },
      {
        'id': '2',
        'name': 'Math Club',
        'description': 'Explore the world of mathematics',
        'type': 'Academic',
        'imageUrl': null,
        'memberCount': 32,
      },
      {
        'id': '3',
        'name': 'Cultural Club',
        'description': 'Celebrate diversity and culture',
        'type': 'Arts',
        'imageUrl': null,
        'memberCount': 56,
      },
    ];
  }

  static Future<List<Map<String, dynamic>>> getUserClubs() async {
    // For demo purposes, return mock data
    await Future.delayed(Duration(seconds: 1));
    
    return [
      {
        'id': '1',
        'name': 'Coding',
        'description': 'For coding enthusiasts and developers',
        'type': 'Club',
        'imageUrl': null,
        'memberCount': 45,
      },
      {
        'id': '2',
        'name': 'Math',
        'description': 'Explore the world of mathematics',
        'type': 'Club',
        'imageUrl': null,
        'memberCount': 32,
      },
      {
        'id': '3',
        'name': 'Cultural',
        'description': 'Celebrate diversity and culture',
        'type': 'Club',
        'imageUrl': null,
        'memberCount': 56,
      },
    ];
  }

  static Future<void> saveUserClubs(List<String> clubIds) async {
    // For demo purposes, just delay
    await Future.delayed(Duration(seconds: 1));
  }

  static Future<void> joinClub(String clubId) async {
    // For demo purposes, just delay
    await Future.delayed(Duration(seconds: 1));
  }

  static Future<void> leaveClub(String clubId) async {
    // For demo purposes, just delay
    await Future.delayed(Duration(seconds: 1));
  }
}

