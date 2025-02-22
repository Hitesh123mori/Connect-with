import 'package:connect_with/providers/post_provider.dart';
import 'package:connect_with/utils/shimmer_effects/common/posts/post_card_shimmer_effect.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/Post/post_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  late Future<void> _postsFuture;

  @override
  void initState() {
    super.initState();
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    _postsFuture = postProvider.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.theme['secondaryColor'].withOpacity(0.9),
      body: FutureBuilder(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: PostCardShimmerEffect());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading posts"));
          }

          return Consumer<PostProvider>(
            builder: (context, postProvider, child) {
              return postProvider.isLoading
                  ? Center(child: PostCardShimmerEffect())
                  : postProvider.posts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                            Image.asset(
                              "assets/ils/no_posts.png",
                              height: 250,
                              width: 250,
                            ),
                             SizedBox(height: 20,),
                             Text(
                               "Create first post!",
                               style: GoogleFonts.poppins(
                                 fontWeight: FontWeight.bold,
                                 fontSize: 20,
                                 color: Colors.grey,
                               ),
                             ),

                          ],
                        ))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: postProvider.posts.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10),
                              child: PostCard(post: postProvider.posts[index]),
                            );
                          },
                        );
            },
          );
        },
      ),
    );
  }
}
