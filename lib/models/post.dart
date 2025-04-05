class Post {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorImage;
  final String? content;
  final String? imageUrl;
  final int likes;
  final int comments;
  final String timeAgo;
  final bool isLiked;
  final bool isSaved;

  Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorImage,
    this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.timeAgo,
    this.isLiked = false,
    this.isSaved = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorImage: json['authorImage'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      likes: json['likes'],
      comments: json['comments'],
      timeAgo: json['timeAgo'],
      isLiked: json['isLiked'] ?? false,
      isSaved: json['isSaved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorImage': authorImage,
      'content': content,
      'imageUrl': imageUrl,
      'likes': likes,
      'comments': comments,
      'timeAgo': timeAgo,
      'isLiked': isLiked,
      'isSaved': isSaved,
    };
  }
}

