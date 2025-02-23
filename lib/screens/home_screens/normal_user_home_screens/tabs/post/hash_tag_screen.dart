import 'package:connect_with/apis/common/post/post_api.dart';
import 'package:connect_with/models/common/post_models/hashtag_model.dart';
import 'package:connect_with/models/common/post_models/post_model.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/shimmer_effects/common/posts/post_card_shimmer_effect.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/Post/post_card.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HashTagScreen extends StatefulWidget {
  final String id;
  const HashTagScreen({super.key, required this.id});

  @override
  State<HashTagScreen> createState() => _HashTagScreenState();
}

class _HashTagScreenState extends State<HashTagScreen> {

  List<PostModel> posts = [];
  bool isLoading = true;

  HashTagsModel? hasmodel ;

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await fetchPosts();
    _refreshController.refreshCompleted();
  }


  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    setState(() => isLoading = true);

    var response = await PostApis.getHashTag(widget.id ?? "", widget.id ?? "");

    if (response != null && response is Map<String, dynamic>) {
      hasmodel = HashTagsModel.fromJson(response);
    }

    List<PostModel> fetchedPosts = [];

    if (hasmodel?.posts != null) {
      for (String postId in hasmodel!.posts!) {
        var postResponse = await PostApis.getPost(postId);
        if (postResponse != null && postResponse is Map<String, dynamic>) {
          fetchedPosts.add(PostModel.fromJson(postResponse));
        }
      }
    }

    setState(() {
      posts = fetchedPosts;
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.theme['secondaryColor'],
      appBar: AppBar(
        surfaceTintColor: AppColors.theme['primaryColor'],
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert_rounded, color: Colors.black),
          ),
          SizedBox(width: 5),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 35,
            color: Colors.black,
          ),
        ),
        backgroundColor: AppColors.theme['secondaryColor'],
        centerTitle: true,
      ),
      body:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.theme['primaryColor']!.withOpacity(0.1),
                    child: Center(
                        child: Text(
                          "#",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 40),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text18(text: hasmodel?.name ?? ""),
                      Text16(
                          isBold: false,
                          text: hasmodel?.followers == "0"
                              ? "Be the first follower"
                              : "${HelperFunctions.formatNumber(hasmodel?.followers.toString())} Followers"),
                      SizedBox(height: 10),
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade400)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5),
                            child: Text16(text: "Follow"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            Expanded(
              child: isLoading
                  ? Center(child: PostCardShimmerEffect())
                  : posts.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/ils/no_posts.png",
                      height: 250,
                      width: 250,
                    ),
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
                  : SmartRefresher(
                header: WaterDropMaterialHeader(
                  backgroundColor: AppColors.theme['primaryColor'].withOpacity(0.9),
                  color: Colors.white,
                ),
                controller: _refreshController,
                enablePullDown: true,
                onRefresh: _onRefresh,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
                      child: PostCard(post: posts[index], onHashOpen: false),
                    );
                  },
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
}
