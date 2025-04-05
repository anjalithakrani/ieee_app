import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/models/event.dart';
import 'package:campus_app/providers/auth_provider.dart';
import 'package:campus_app/providers/events_provider.dart';
import 'package:campus_app/screens/action_center_screen.dart';
import 'package:campus_app/screens/events_screen.dart';
import 'package:campus_app/screens/feed_screen.dart';
import 'package:campus_app/screens/profile_screen.dart';
import 'package:campus_app/utils/app_theme.dart';
import 'package:campus_app/widgets/event_card.dart';
import 'package:campus_app/widgets/feature_card.dart';
import 'package:campus_app/widgets/app_header.dart'; // Import AppHeader
 
class HomeScreen extends StatefulWidget {
  final bool isGuest;
  final int currentIndex;

  const HomeScreen({this.isGuest = false, this.currentIndex = 0});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final eventsProvider =
          Provider.of<EventsProvider>(context, listen: false);
      await eventsProvider.fetchUpcomingEvents();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return FeedScreen();
      case 2:
        return EventsScreen();
      case 3:
        return ActionCenterScreen();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    final authProvider = Provider.of<AuthProvider>(context);
    final eventsProvider = Provider.of<EventsProvider>(context);
    final upcomingEvents = eventsProvider.upcomingEvents;
    final user = authProvider.currentUser;

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryColor,
            ),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with greeting and profile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning,',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            widget.isGuest ? 'Guest' : user?.name ?? 'User',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ProfileScreen()),
                          );
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: AppTheme.cardColor,
                          backgroundImage: user?.profileImage != null
                              ? NetworkImage(user!.profileImage!)
                              : null,
                          child: user?.profileImage == null
                              ? Icon(
                                  Icons.person,
                                  color: AppTheme.textSecondaryColor,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Upcoming events section
                  Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  upcomingEvents.isEmpty
                      ? Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              'No upcoming events',
                              style: TextStyle(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: upcomingEvents.length,
                            itemBuilder: (context, index) {
                              return EventCard(
                                event: upcomingEvents[index],
                                onTap: () {
                                  // Navigate to event details
                                },
                              );
                            },
                          ),
                        ),
                  SizedBox(height: 24),

                  // In the spotlight section
                  Text(
                    'In the Spotlight',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CRACK THE CODE',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '12 Feb 2023 | Tapas Hall',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppHeader(title: "IEEE VESIT"), // Updated AppBar
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.cardColor,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondaryColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed_outlined),
            activeIcon: Icon(Icons.feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Action',
          ),
        ],
      ),
    );
  }
}
