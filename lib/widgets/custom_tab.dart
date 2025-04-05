import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final String label;
  final bool isSelected;

  const CustomTab({
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

