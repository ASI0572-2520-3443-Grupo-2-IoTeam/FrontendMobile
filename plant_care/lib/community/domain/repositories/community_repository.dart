import 'package:plant_care/community/domain/models/post.dart';
import 'package:plant_care/community/domain/models/comment.dart';

abstract class CommunityRepository {
  Future<List<Post>> getPosts(String token);
  Future<bool> checkIfMember(String userId, String token);
  Future<void> joinCommunity(String userId, String token);
  Future<Map<String, String>> getMemberNames(String token);
  Future<void> createPost(String token, String userId, String title, String content, String species, String tag);
  Future<void> deletePost(String token, String userId, int postId);
  Future<List<Comment>> getComments(String token);
  Future<void> createComment(String token, String userId, int postId, String text);
  Future<void> deleteComment(String token, String userId, String commentId);
  Future<int> getReactions(String token, int postId);
  Future<bool> toggleReaction(String token, String userId, int postId);
}
