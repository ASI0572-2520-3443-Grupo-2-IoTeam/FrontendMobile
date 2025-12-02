import 'package:flutter/material.dart';
import 'package:plant_care/iam/presentation/providers/auth_provider.dart';
import 'package:plant_care/community/domain/models/post.dart';
import 'package:plant_care/community/domain/repositories/community_repository.dart';
import 'package:plant_care/community/presentation/providers/community_provider.dart';
import 'package:plant_care/community/presentation/widgets/post_card.dart';
import 'package:plant_care/community/presentation/widgets/create_post_dialog.dart';
import 'package:plant_care/community/presentation/widgets/community_info_cards.dart';
import 'package:plant_care/shared/presentation/widgets/custom_bottom_navbar.dart';
import 'package:provider/provider.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunityProvider>().loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommunityProvider>();
    final posts = provider.posts;
    final isLoading = provider.isLoading;
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F0), // Light cream background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Community',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF064E3B), // Dark green
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Connect with fellow plant enthusiasts and share your journey',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const CreatePostDialog(),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Create Post',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF84CC16), // Lime green
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Feed Header
              Row(
                children: const [
                  Icon(Icons.people_outline, color: Color(0xFF84CC16)),
                  SizedBox(width: 8),
                  Text(
                    'Community Feed',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Posts List
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (posts.isEmpty)
                const Center(child: Text('No posts yet.'))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final currentUser = context.read<AuthProvider>().currentUser;
                    final isOwner = currentUser != null && post.authorId == currentUser.id;

                    return PostCard(
                      post: post,
                      isOwner: isOwner,
                      onDelete: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Post'),
                            content: const Text('Are you sure you want to delete this post?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          if (context.mounted) {
                            try {
                              await provider.deletePost(post.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Post deleted successfully')),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error deleting post: $e')),
                                );
                              }
                            }
                          }
                        }
                      },
                    );
                  },
                ),
              const SizedBox(height: 24),
              const PlantExpertsCard(),
              const SizedBox(height: 16),
              const ActiveChallengesCard(),
              const SizedBox(height: 16),
              const PopularGuidesCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }
}
