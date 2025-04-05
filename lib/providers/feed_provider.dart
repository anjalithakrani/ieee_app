import 'package:flutter/material.dart';
import 'package:campus_app/models/post.dart';
import 'package:campus_app/services/api_service.dart';

class FeedProvider with ChangeNotifier {
  List<Post> _posts = [];

  List<Post> get posts => _posts;

  Future<void> fetchPosts() async {
    try {
      final postsData = await ApiService.getPosts();
      _posts = postsData.map((data) => Post.fromJson(data)).toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> likePost(String postId) async {
    try {
      await ApiService.likePost(postId);

      // Update local state
      final index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        final post = _posts[index];
        _posts[index] = Post(
          id: post.id,
          authorId: post.authorId,
          authorName: post.authorName,
          authorImage: post.authorImage,
          content: post.content,
          imageUrl: post.imageUrl,
          likes: post.isLiked ? post.likes - 1 : post.likes + 1,
          comments: post.comments,
          timeAgo: post.timeAgo,
          isLiked: !post.isLiked,
          isSaved: post.isSaved,
        );
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> savePost(String postId) async {
    try {
      await ApiService.savePost(postId);

      // Update local state
      final index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        final post = _posts[index];
        _posts[index] = Post(
          id: post.id,
          authorId: post.authorId,
          authorName: post.authorName,
          authorImage: post.authorImage,
          content: post.content,
          imageUrl: post.imageUrl,
          likes: post.likes,
          comments: post.comments,
          timeAgo: post.timeAgo,
          isLiked: post.isLiked,
          isSaved: !post.isSaved,
        );
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> createPost(String content, String? imageUrl) async {
    try {
      final newPostData = await ApiService.createPost(content, imageUrl);
      final newPost = Post.fromJson(newPostData);
      _posts.insert(0, newPost);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
