import 'package:connect_with/apis/common/post/post_api.dart';
import 'package:connect_with/models/common/post_models/post_model.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/providers/general_provider.dart';
import 'package:connect_with/providers/graph_provider.dart';
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
  List<PostModel> posts = [];
  bool isLoading = false;

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    setState(() {
      isLoading = true;
    });

    final graphProvider = Provider.of<GraphProvider>(context, listen: false);
    await graphProvider.createGraph(context);

    try {
      for (String id in graphProvider.suggestedPosts) {
        PostModel p = PostModel.fromJson(await PostApis.getPost(id) ?? {});
        posts.add(p);
      }
    } catch (e) {
      print(e);
    }


    if(posts.isEmpty){
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      await postProvider.getPosts() ;
      posts = postProvider.posts ;
    }
    setState(() {
      isLoading = false;
    });
  }

  void _onRefresh() async {
    await _fetchPosts();
    _refreshController.refreshCompleted();

  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PostProvider, GraphProvider>(
        builder: (context, postProvider, graphProvider, child) {
      return Scaffold(
        backgroundColor: AppColors.theme['secondaryColor'].withOpacity(0.9),
        body: SmartRefresher(
          header: WaterDropMaterialHeader(
            backgroundColor: AppColors.theme['primaryColor'].withOpacity(0.9),
            color: Colors.white,
          ),
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _onRefresh,
          child: isLoading ? PostCardShimmerEffect() :
           ( posts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/ils/no_posts.png",
                          height: 250, width: 250),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10),
                      child: PostCard(post: posts[index]),
                    );
                  },
                ) ),
        ),
      );
    });
  }
}
