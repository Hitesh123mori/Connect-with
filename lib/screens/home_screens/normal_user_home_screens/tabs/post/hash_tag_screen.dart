import 'package:connect_with/apis/common/post/post_api.dart';
import 'package:connect_with/models/common/post_models/hashtag_model.dart';
import 'package:connect_with/models/common/post_models/post_model.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/utils/helper_functions/helper_functions.dart';
import 'package:connect_with/utils/shimmer_effects/common/posts/post_card_shimmer_effect.dart';
import 'package:connect_with/utils/theme/colors.dart';
import 'package:connect_with/utils/widgets/common_widgets/Post/post_card.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_16.dart';
import 'package:connect_with/utils/widgets/common_widgets/text_style_formats/text_18.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HashTagScreen extends StatefulWidget {
  final String id;
  const HashTagScreen({super.key, required this.id});

  @override
  State<HashTagScreen> createState() => _HashTagScreenState();
}

class _HashTagScreenState extends State<HashTagScreen> {

  bool isLoading = true;
  HashTagsModel? hasmodel;
  List<PostModel> posts = [] ;


  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<void> fetchPosts() async {
    setState(() => isLoading = true);

    var response = await PostApis.getHashTag(widget.id, widget.id);

    if (response != null && response is Map<String, dynamic>) {
      hasmodel = HashTagsModel.fromJson(response);
      final userId = Provider.of<AppUserProvider>(context, listen: false).user?.userID;
    }

    List<PostModel> fetchedPosts = [];

    if (hasmodel?.posts != null) {
      for (String postId in hasmodel!.posts!) {
        var postResponse = await PostApis.getPost(postId);
        if (postResponse != null) {
          fetchedPosts.add(PostModel.fromJson(postResponse));
        }
      }
    }
    print("size of hashtag posts : ${fetchedPosts.length}") ;


    setState(() {
      posts = fetchedPosts;
      isLoading = false;
    });
  }

  void _onRefresh() async {
    fetchPosts();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  void toggleFollow(String uid,bool isFollow) async {

    setState(() {
      isFollow  = !isFollow ;
    });

    if (isFollow) {
      await PostApis.addFollowerToHashTag(widget.id, uid);
    } else {
      await PostApis.removeFollowerFromHashTag(widget.id, uid);
    }

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<AppUserProvider>(builder: (context, appUserProvider, child) {
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
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.keyboard_arrow_left_rounded, size: 35, color: Colors.black),
          ),
          backgroundColor: AppColors.theme['secondaryColor'],
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: PostApis.getHashTagStream(widget.id, widget.id),
            builder: (context,snapshot){

              if (snapshot.hasError) {
                return const Center(child: Text("Error loading post"));
              }

              bool isFollowing = false;
              if(snapshot.hasData){
                hasmodel = snapshot.data ;
                 isFollowing = hasmodel?.followers?.contains(appUserProvider.user?.userID) ?? false;
              }else{
                // return Center(child: Text("Data Loading...",style: TextStyle(color: AppColors.theme['tertiaryColor'].withOpacity(0.4)),));
              }

              return Padding(
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
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 40),
                              ),
                            ),
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
                                text: hasmodel?.followers?.length.toString() == "0"
                                    ? "Be the first follower"
                                    : "${HelperFunctions.formatNumber(hasmodel?.followers?.length.toString())} Followers",
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: (){
                                  toggleFollow(appUserProvider.user?.userID ?? "",isFollowing);
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey.shade400),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                                    child: Text16(text: isFollowing ? "Unfollow" : "Follow"),
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
                          : posts?.isEmpty ?? true
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/ils/no_posts.png", height: 250, width: 250),
                            SizedBox(height: 20),
                            Text(
                              "Create first post!",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                          : SmartRefresher(
                        header: WaterDropMaterialHeader(
                          backgroundColor: AppColors.theme['primaryColor']!.withOpacity(0.9),
                          color: Colors.white,
                        ),
                        controller: _refreshController,
                        enablePullDown: true,
                        onRefresh: _onRefresh,
                        child:  ListView.builder(
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
              );
         })
      );
    });
  }
}
