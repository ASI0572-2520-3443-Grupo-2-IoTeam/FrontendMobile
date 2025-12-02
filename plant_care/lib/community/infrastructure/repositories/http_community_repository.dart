import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:plant_care/community/domain/models/post.dart';
import 'package:plant_care/community/domain/models/comment.dart';
import 'package:plant_care/community/domain/repositories/community_repository.dart';

class HttpCommunityRepository implements CommunityRepository {
  final String baseUrl = 'https://plantcare-awcchhb2bfg3hxgf.canadacentral-01.azurewebsites.net/api/v1/community';

  @override
  Future<List<Post>> getPosts(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts'),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        debugPrint('❌ Failed to fetch posts: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ Error fetching posts: $e');
      return [];
    }
  }

  @override
  Future<bool> checkIfMember(String userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/members'),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> members = jsonDecode(response.body);
        // Check if any member has the same userId
        // Assuming the API returns a list of objects with a 'userId' or 'id' field
        // Based on typical implementations, let's check for 'userId' or 'id'
        // If the list is just IDs, we check directly. 
        // But usually it's objects. Let's assume objects for now and print to debug.
        
        for (var member in members) {
          // Adjust this based on actual API response structure
          // If member is a map
          if (member is Map<String, dynamic>) {
             if (member['userId'] == userId || member['id'] == userId) {
               return true;
             }
          }
        }
        return false;
      } else {
        debugPrint('❌ Failed to fetch members: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error checking membership: $e');
      return false;
    }
  }

  @override
  Future<Map<String, String>> getMemberNames(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/members'),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final Map<String, String> memberNames = {};
        for (var item in data) {
          if (item is Map<String, dynamic>) {
            final userId = item['userId'] as String?;
            final username = item['username'] as String?;
            if (userId != null && username != null) {
              memberNames[userId] = username;
            }
          }
        }
        return memberNames;
      } else {
        debugPrint('❌ Failed to fetch members for names: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      debugPrint('❌ Error fetching member names: $e');
      return {};
    }
  }

  @override
  Future<void> joinCommunity(String userId, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/members?userId=$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Successfully joined community');
      } else {
        throw Exception('Failed to join community: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error joining community: $e');
      rethrow;
    }
  }

  @override
  Future<void> createPost(String token, String userId, String title, String content, String species, String tag) async {
    try {
      final uri = Uri.parse('$baseUrl/posts').replace(queryParameters: {
        'userId': userId,
        'title': title,
        'content': content,
        'species': species,
        'tag': tag,
      });

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Successfully created post');
      } else {
        throw Exception('Failed to create post: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error creating post: $e');
      rethrow;
    }
  }
  @override
  Future<void> deletePost(String token, String userId, int postId) async {
    try {
      final uri = Uri.parse('$baseUrl/posts/$postId').replace(queryParameters: {
        'userId': userId,
      });

      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('✅ Successfully deleted post');
      } else {
        throw Exception('Failed to delete post: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error deleting post: $e');
      rethrow;
    }
  }
  @override
  Future<List<Comment>> getComments(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/comments'),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Comment.fromJson(json)).toList();
      } else {
        debugPrint('❌ Failed to fetch comments: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ Error fetching comments: $e');
      return [];
    }
  }

  @override
  Future<void> createComment(String token, String userId, int postId, String text) async {
    try {
      final uri = Uri.parse('$baseUrl/comments').replace(queryParameters: {
        'userId': userId,
        'postId': postId.toString(),
        'text': text,
      });

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Successfully created comment');
      } else {
        throw Exception('Failed to create comment: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error creating comment: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteComment(String token, String userId, String commentId) async {
    try {
      final uri = Uri.parse('$baseUrl/comments/$commentId').replace(queryParameters: {
        'userId': userId,
      });

      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('✅ Successfully deleted comment');
      } else {
        throw Exception('Failed to delete comment: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error deleting comment: $e');
      rethrow;
    }
  }
  @override
  Future<int> getReactions(String token, int postId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reactions?postId=$postId'),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        debugPrint('❌ Failed to fetch reactions: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      debugPrint('❌ Error fetching reactions: $e');
      return 0;
    }
  }

  @override
  Future<bool> toggleReaction(String token, String userId, int postId) async {
    try {
      final uri = Uri.parse('$baseUrl/reactions').replace(queryParameters: {
        'userId': userId,
        'postId': postId.toString(),
      });

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        return response.body.toLowerCase() == 'true';
      } else {
        throw Exception('Failed to toggle reaction: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error toggling reaction: $e');
      rethrow;
    }
  }
}
