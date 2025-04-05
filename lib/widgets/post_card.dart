import 'package:flutter/material.dart';
import 'package:campus_app/models/post.dart';
import 'package:campus_app/utils/app_theme.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onSave;

  const PostCard({
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.backgroundColor,
                  backgroundImage: post.authorImage != null
                      ? NetworkImage(post.authorImage!)
                      : null,
                  child: post.authorImage == null
                      ? Text(
                          post.authorName.substring(0, 1),
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${post.timeAgo} ago',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                    color: AppTheme.textSecondaryColor,
                  ),
                  onPressed: () {
                    // Show post options
                  },
                ),
              ],
            ),
          ),
          
          // Post content
          if (post.content != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                post.content!,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          
          // Post image
          if (post.imageUrl != null)
            Container(
              width: double.infinity,
              height: 200,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                image: DecorationImage(
                  image: NetworkImage(post.imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          
          // Post actions
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  icon: Icons.favorite_border,
                  label: post.likes.toString(),
                  onTap: onLike,
                ),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: post.comments.toString(),
                  onTap: onComment,
                ),
                _buildActionButton(
                  icon: Icons.send,
                  label: '',
                  onTap: onShare,
                ),
                _buildActionButton(
                  icon: Icons.bookmark_border,
                  label: '',
                  onTap: onSave,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppTheme.textSecondaryColor,
          ),
          if (label.isNotEmpty) ...[
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

