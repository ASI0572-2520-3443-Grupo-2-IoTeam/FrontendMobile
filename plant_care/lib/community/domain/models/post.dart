class Post {
  final int id;
  final String title;
  final String content;
  final String authorId;
  final DateTime createdAt;
  final bool highlighted;
  
  final String species;
  final String tag;
  
  // UI specific fields that might need to be fetched separately or defaulted
  final String authorName;
  final String authorAvatarUrl;
  final String location;
  final String? imageUrl;
  final int likes;
  final int comments;
  final bool isLiked;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.createdAt,
    required this.highlighted,
    required this.species,
    required this.tag,
    this.authorName = 'Community Member',
    this.authorAvatarUrl = '',
    this.location = 'Unknown Location',
    this.imageUrl,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      authorId: json['authorId'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      highlighted: json['highlighted'] as bool? ?? false,
      species: json['species'] as String? ?? '',
      tag: json['tag'] as String? ?? '',
      // Default values for fields not in API yet
      authorName: 'User ${json['authorId'].toString().substring(0, 5)}...',
      likes: 0,
      comments: 0,
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
