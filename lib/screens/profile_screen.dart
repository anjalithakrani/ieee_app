import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/models/club.dart';
import 'package:campus_app/providers/auth_provider.dart';
import 'package:campus_app/providers/clubs_provider.dart';
import 'package:campus_app/screens/login_screen.dart';
import 'package:campus_app/utils/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  List<Club> _userClubs = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final clubsProvider = Provider.of<ClubsProvider>(context, listen: false);
      await clubsProvider.fetchUserClubs();
      setState(() {
        _userClubs = clubsProvider.userClubs;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile data')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _logout() async {
    try {
      await Provider.of<AuthProvider>(context, listen: false).logout();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to logout')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 60, bottom: 24),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppTheme.cardColor,
                          backgroundImage: user?.profileImage != null
                              ? NetworkImage(user!.profileImage!)
                              : null,
                          child: user?.profileImage == null
                              ? Icon(
                                  Icons.person,
                                  size: 50,
                                  color: AppTheme.textSecondaryColor,
                                )
                              : null,
                        ),
                        SizedBox(height: 16),
                        Text(
                          user?.name ?? 'User',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          user?.role ?? 'Student',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bio section
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BIO',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          user?.bio ??
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at eros. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at eros.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Clubs section
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CLUBS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        _userClubs.isEmpty
                            ? Center(
                                child: Text(
                                  'No clubs joined yet',
                                  style: TextStyle(
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: _userClubs
                                    .take(3)
                                    .map((club) => Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 24,
                                              backgroundColor:
                                                  AppTheme.backgroundColor,
                                              child: Text(
                                                club.name.substring(0, 1),
                                                style: TextStyle(
                                                  color: AppTheme.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              club.name,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              club.type,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                    AppTheme.textSecondaryColor,
                                              ),
                                            ),
                                          ],
                                        ))
                                    .toList(),
                              ),
                      ],
                    ),
                  ),

                  // Settings options
                  Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          onTap: () {
                            // Navigate to edit profile
                          },
                        ),
                        Divider(color: AppTheme.dividerColor, height: 1),
                        _buildSettingsItem(
                          icon: Icons.notifications_none,
                          title: 'Notifications',
                          onTap: () {
                            // Navigate to notifications settings
                          },
                        ),
                        Divider(color: AppTheme.dividerColor, height: 1),
                        _buildSettingsItem(
                          icon: Icons.security,
                          title: 'Privacy & Security',
                          onTap: () {
                            // Navigate to privacy settings
                          },
                        ),
                        Divider(color: AppTheme.dividerColor, height: 1),
                        _buildSettingsItem(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          onTap: () {
                            // Navigate to help
                          },
                        ),
                        Divider(color: AppTheme.dividerColor, height: 1),
                        _buildSettingsItem(
                          icon: Icons.logout,
                          title: 'Logout',
                          onTap: _logout,
                          isDestructive: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppTheme.textSecondaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.white,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppTheme.textSecondaryColor,
      ),
      onTap: onTap,
    );
  }
}
