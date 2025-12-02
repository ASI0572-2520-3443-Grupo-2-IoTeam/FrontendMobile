import 'package:flutter/material.dart';
import 'package:plant_care/community/domain/models/post.dart';
import 'package:plant_care/community/domain/models/comment.dart';
import 'package:plant_care/community/domain/repositories/community_repository.dart';
import 'package:plant_care/iam/presentation/providers/auth_provider.dart';

class CommunityProvider extends ChangeNotifier {
  final CommunityRepository _repository;
  final AuthProvider _authProvider;

  bool _isLoading = false;
  bool _isMember = false;
  List<Post> _posts = [];

  CommunityProvider({
    required CommunityRepository repository,
    required AuthProvider authProvider,
  })  : _repository = repository,
        _authProvider = authProvider;

  bool get isLoading => _isLoading;
  bool get isMember => _isMember;
  List<Post> get posts => _posts;

  Future<void> checkMembership() async {
    final user = _authProvider.currentUser;
    final token = _authProvider.token;

    if (user == null || token == null) {
      _isMember = false;
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      _isMember = await _repository.checkIfMember(user.id, token);
    } catch (e) {
      debugPrint('❌ Error checking membership: $e');
      _isMember = false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> joinCommunity() async {
    final user = _authProvider.currentUser;
    final token = _authProvider.token;

    if (user == null || token == null) return;

    _setLoading(true);
    try {
      await _repository.joinCommunity(user.id, token);
      _isMember = true;
    } catch (e) {
      debugPrint('❌ Error joining community: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadPosts() async {
    final token = _authProvider.token;
    if (token == null) return;

    _setLoading(true);
    try {
      // Fetch posts, member names, and comments in parallel
      final results = await Future.wait([
        _repository.getPosts(token),
        _repository.getMemberNames(token),
        _repository.getComments(token),
      ]);

      final postsData = results[0] as List<Post>;
      final memberNames = results[1] as Map<String, String>;
      final allComments = results[2] as List<Comment>;

      // Map member names, comment counts, and fetch likes for each post
      // Note: Fetching likes individually might be slow if there are many posts.
      // Ideally, the backend should return this info in getPosts.
      // For now, we'll fetch them in parallel for the displayed posts.
      
      final postsWithLikes = await Future.wait(postsData.map((post) async {
        final commentCount = allComments.where((c) => c.postId == post.id).length;
        int likesCount = 0;
        try {
           likesCount = await _repository.getReactions(token, post.id);
        } catch (e) {
          debugPrint('Error fetching likes for post ${post.id}: $e');
        }

        return Post(
          id: post.id,
          title: post.title,
          content: post.content,
          authorId: post.authorId,
          createdAt: post.createdAt,
          highlighted: post.highlighted,
          species: post.species,
          tag: post.tag,
          authorName: memberNames[post.authorId] ?? 'Unknown User',
          comments: commentCount,
          likes: likesCount,
          // We don't have isLiked from API yet, defaulting to false
          isLiked: false, 
        );
      }));

      _posts = postsWithLikes;

      // Sort by newest first
      _posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('❌ Error loading posts: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleLike(int postId) async {
    final user = _authProvider.currentUser;
    final token = _authProvider.token;

    if (user == null || token == null) return;

    // Optimistic update
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      final newIsLiked = !post.isLiked;
      final newLikes = newIsLiked ? post.likes + 1 : (post.likes > 0 ? post.likes - 1 : 0);
      
      // Update local state immediately
      _posts[index] = Post(
        id: post.id,
        title: post.title,
        content: post.content,
        authorId: post.authorId,
        createdAt: post.createdAt,
        highlighted: post.highlighted,
        species: post.species,
        tag: post.tag,
        authorName: post.authorName,
        authorAvatarUrl: post.authorAvatarUrl,
        location: post.location,
        imageUrl: post.imageUrl,
        comments: post.comments,
        likes: newLikes,
        isLiked: newIsLiked,
      );
      notifyListeners();

      try {
        final serverIsLiked = await _repository.toggleReaction(token, user.id, postId);
        
        // If server response differs from optimistic update (e.g. we thought it was false but it was true)
        // we might need to correct it. But since we don't know initial state perfectly, 
        // we trust the toggle action flipped it.
        // If the server returns the *new* state, we can verify.
        
        if (serverIsLiked != newIsLiked) {
           // Correction needed if server disagrees
           // But usually toggle returns the new state.
           // Let's update with server truth if needed, or just keep optimistic if consistent.
           if (serverIsLiked != newIsLiked) {
             _posts[index] = Post(
                id: post.id,
                title: post.title,
                content: post.content,
                authorId: post.authorId,
                createdAt: post.createdAt,
                highlighted: post.highlighted,
                species: post.species,
                tag: post.tag,
                authorName: post.authorName,
                authorAvatarUrl: post.authorAvatarUrl,
                location: post.location,
                imageUrl: post.imageUrl,
                comments: post.comments,
                likes: serverIsLiked ? post.likes + 1 : (post.likes > 0 ? post.likes - 1 : 0), // Rough correction
                isLiked: serverIsLiked,
             );
             notifyListeners();
           }
        }
      } catch (e) {
        debugPrint('❌ Error toggling like: $e');
        // Revert optimistic update
        _posts[index] = post;
        notifyListeners();
      }
    }
  }

  Future<void> createPost({
    required String title,
    required String content,
    required String species,
    required String tag,
  }) async {
    final user = _authProvider.currentUser;
    final token = _authProvider.token;

    if (user == null || token == null) return;

    _setLoading(true);
    try {
      await _repository.createPost(token, user.id, title, content, species, tag);
      // Reload posts to show the new one
      await loadPosts();
    } catch (e) {
      debugPrint('❌ Error creating post: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deletePost(int postId) async {
    final user = _authProvider.currentUser;
    final token = _authProvider.token;

    if (user == null || token == null) return;

    _setLoading(true);
    try {
      await _repository.deletePost(token, user.id, postId);
      // Reload posts to update the list
      await loadPosts();
    } catch (e) {
      debugPrint('❌ Error deleting post: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Comment>> getCommentsForPost(int postId) async {
    final token = _authProvider.token;
    if (token == null) return [];

    try {
      final allComments = await _repository.getComments(token);
      return allComments.where((c) => c.postId == postId).toList();
    } catch (e) {
      debugPrint('❌ Error loading comments: $e');
      return [];
    }
  }

  Future<void> createComment(int postId, String text) async {
    final user = _authProvider.currentUser;
    final token = _authProvider.token;

    if (user == null || token == null) return;

    try {
      await _repository.createComment(token, user.id, postId, text);
      notifyListeners(); // Notify to refresh UI if needed
    } catch (e) {
      debugPrint('❌ Error creating comment: $e');
      rethrow;
    }
  }

  Future<void> deleteComment(String commentId) async {
    final user = _authProvider.currentUser;
    final token = _authProvider.token;

    if (user == null || token == null) return;

    try {
      await _repository.deleteComment(token, user.id, commentId);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error deleting comment: $e');
      rethrow;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
