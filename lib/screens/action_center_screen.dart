import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/models/class.dart';
import 'package:campus_app/models/event.dart';
import 'package:campus_app/providers/events_provider.dart';
import 'package:campus_app/screens/home_screen.dart';
import 'package:campus_app/utils/app_theme.dart';
import 'package:campus_app/widgets/class_card.dart';
import 'package:campus_app/widgets/event_list_item.dart';

class ActionCenterScreen extends StatefulWidget {
  @override
  _ActionCenterScreenState createState() => _ActionCenterScreenState();
}

class _ActionCenterScreenState extends State<ActionCenterScreen> {
  bool _isLoading = true;
  List<Class> _todayClasses = [];
  List<Event> _todayEvents = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final eventsProvider =
          Provider.of<EventsProvider>(context, listen: false);
      await eventsProvider.fetchTodayEvents();

      // Mock classes data for now
      _todayClasses = [
        Class(
          id: '1',
          name: 'Discrete Math',
          startTime: '9:00 AM',
          endTime: '10:30 PM',
          location: 'Room 101',
          instructor: 'Dr. Smith',
        ),
        Class(
          id: '2',
          name: 'Cryptography',
          startTime: '2:00 PM',
          endTime: '3:30 PM',
          location: 'Room 203',
          instructor: 'Dr. Johnson',
        ),
      ];

      _todayEvents = eventsProvider.todayEvents;
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

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Action Center',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {
              // Navigate to notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.apps),
            onPressed: () {
              // Open app drawer or menu
            },
          ),
        ],
        elevation: 0,
        backgroundColor: AppTheme.backgroundColor,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshData,
              color: AppTheme.primaryColor,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today's classes section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Today Classes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to all classes
                          },
                          child: Text(
                            'See All',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _todayClasses.isEmpty
                        ? Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppTheme.cardColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                'No classes today',
                                style: TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                            ),
                          )
                        : Row(
                            children: _todayClasses
                                .map((classItem) => Expanded(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        child: ClassCard(classItem: classItem),
                                      ),
                                    ))
                                .toList(),
                          ),
                    SizedBox(height: 24),

                    // Today's events section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Today Events',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to all events
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => HomeScreen(currentIndex: 2),
                              ),
                            );
                          },
                          child: Text(
                            'See All',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _todayEvents.isEmpty
                        ? Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppTheme.cardColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                'No events today',
                                style: TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: _todayEvents
                                .map((event) => Padding(
                                      padding: EdgeInsets.only(bottom: 16),
                                      child: EventListItem(
                                        event: event,
                                        onTap: () {
                                          // Navigate to event details
                                        },
                                      ),
                                    ))
                                .toList(),
                          ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          if (index != 3) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => HomeScreen(currentIndex: index),
              ),
            );
          }
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
