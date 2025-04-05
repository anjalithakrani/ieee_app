import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          Image.asset('lib/assets/logo.jpeg',
              height: 30), // Adjust path to your logo
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
