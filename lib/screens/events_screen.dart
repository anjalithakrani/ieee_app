import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/models/event.dart';
import 'package:campus_app/providers/events_provider.dart';
import 'package:campus_app/screens/home_screen.dart';
import 'package:campus_app/utils/app_theme.dart';
import 'package:campus_app/widgets/event_list_item.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      await Provider.of<EventsProvider>(context, listen: false)
          .fetchAllEvents();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load events')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshEvents() async {
    setState(() {
      _isLoading = true;
    });
    await _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    final eventsProvider = Provider.of<EventsProvider>(context);
    final events = eventsProvider.allEvents;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Events',
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
              onRefresh: _refreshEvents,
              color: AppTheme.primaryColor,
              child: Column(
                children: [
                  // Calendar view (simplified)
                  Container(
                    height: 120,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: 14, // Two weeks of days
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final day = DateTime.now().add(Duration(days: index));
                        final isToday = index == 0;

                        return Container(
                          decoration: BoxDecoration(
                            color: isToday
                                ? AppTheme.primaryColor
                                : AppTheme.cardColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              day.day.toString(),
                              style: TextStyle(
                                color: isToday
                                    ? Colors.white
                                    : AppTheme.textSecondaryColor,
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Events list
                  Expanded(
                    child: events.isEmpty
                        ? Center(
                            child: Text(
                              'No events available',
                              style: TextStyle(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              return EventListItem(
                                event: events[index],
                                onTap: () {
                                  // Navigate to event details
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index != 2) {
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
