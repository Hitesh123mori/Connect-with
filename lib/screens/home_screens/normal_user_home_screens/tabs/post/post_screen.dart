import 'package:connect_with/models/common/post_models/post_model.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/providers/general_provider.dart';
import 'package:connect_with/providers/post_provider.dart';
import 'package:connect_with/utils/shimmer_effects/common/posts/post_card_shimmer_effect.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/Post/post_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final generalProvider = Provider.of<GeneralProvider>(context, listen: false);

    await generalProvider.checkUser() ;
    setState(() {
      postProvider.postsFuture = postProvider.getPosts();
    });
  }

  void _onRefresh() async {
    await _fetchPosts();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(builder: (context,postProvider,child){
      return Scaffold(
        backgroundColor: AppColors.theme['secondaryColor'].withOpacity(0.9),
        body: FutureBuilder<List<PostModel>>(
          future: postProvider.postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: PostCardShimmerEffect());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading posts"));
            }

            final posts = snapshot.data ?? [];

            return SmartRefresher(
              header: WaterDropMaterialHeader(
                backgroundColor: AppColors.theme['primaryColor'].withOpacity(0.9),
                color: Colors.white,
              ),
              controller: _refreshController,
              enablePullDown: true,
              onRefresh: _onRefresh,
              child: posts.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/ils/no_posts.png", height: 250, width: 250),
                    const SizedBox(height: 20),
                    Text(
                      "Create first post!",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                shrinkWrap: false,
                physics: BouncingScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                    child: PostCard(post: posts[index]),
                  );
                },
              ),
            );
          },
        ),
      );
    }
    );
  }
}
