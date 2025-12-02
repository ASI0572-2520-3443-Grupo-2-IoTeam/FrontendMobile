class Comment {
  final String commentId;
  final String content;
  final DateTime createdAt;
  final String authorId;
  final String username;
  final int postId;

  Comment({
    required this.commentId,
    required this.content,
    required this.createdAt,
    required this.authorId,
    required this.username,
    required this.postId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentId'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      authorId: json['authorId'] as String,
      username: json['username'] as String,
      postId: json['postId'] as int,
    );
  }

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
