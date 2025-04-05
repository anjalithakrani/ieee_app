import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/models/post.dart';
import 'package:campus_app/providers/feed_provider.dart';
import 'package:campus_app/utils/app_theme.dart';
import 'package:campus_app/widgets/post_card.dart';
import 'package:campus_app/screens/home_screen.dart';
import 'package:campus_app/widgets/app_header.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: "Edit profile"), // Using the reusable header
    );
  }
}

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  Future<void> _loadFeed() async {
    try {
      await Provider.of<FeedProvider>(context, listen: false).fetchPosts();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load feed')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshFeed() async {
    setState(() {
      _isLoading = true;
    });
    await _loadFeed();
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    final posts = feedProvider.posts;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Feed',
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
              onRefresh: _refreshFeed,
              color: AppTheme.primaryColor,
              child: posts.isEmpty
                  ? Center(
                      child: Text(
                        'No posts available',
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return PostCard(
                          post: posts[index],
                          onLike: () {
                            feedProvider.likePost(posts[index].id);
                          },
                          onComment: () {
                            // Navigate to comments
                          },
                          onShare: () {
                            // Share post
                          },
                          onSave: () {
                            feedProvider.savePost(posts[index].id);
                          },
                        );
                      },
                    ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index != 1) {
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
