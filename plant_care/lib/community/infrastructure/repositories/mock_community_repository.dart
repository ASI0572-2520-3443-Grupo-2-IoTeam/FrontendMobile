import 'package:plant_care/community/domain/models/post.dart';
import 'package:plant_care/community/domain/models/comment.dart';
import 'package:plant_care/community/domain/repositories/community_repository.dart';

class MockCommunityRepository implements CommunityRepository {
  @override
  Future<List<Post>> getPosts(String token) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  @override
  Future<bool> checkIfMember(String userId, String token) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return false; // Default to not a member for testing
  }

  @override
  Future<Map<String, String>> getMemberNames(String token) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {};
  }

  @override
  Future<void> joinCommunity(String userId, String token) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
  @override
  Future<void> createPost(String token, String userId, String title, String content, String species, String tag) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> deletePost(String token, String userId, int postId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<Comment>> getComments(String token) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  @override
  Future<void> createComment(String token, String userId, int postId, String text) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> deleteComment(String token, String userId, String commentId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<int> getReactions(String token, int postId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 0;
  }

  @override
  Future<bool> toggleReaction(String token, String userId, int postId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
