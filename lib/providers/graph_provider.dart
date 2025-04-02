import 'dart:collection';
import 'package:connect_with/apis/common/auth_apis.dart';
import 'package:connect_with/apis/init/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:connect_with/apis/common/post/post_api.dart';
import 'package:connect_with/apis/normal/user_crud_operations/user_details_update.dart';
import 'package:connect_with/apis/organization/organization_crud_operation/organization_crud.dart';
import 'package:connect_with/graph_alogrithms/init/graph_node.dart';
import 'package:connect_with/models/common/post_models/hashtag_model.dart';
import 'package:connect_with/models/common/post_models/post_model.dart';
import 'package:connect_with/models/organization/organization.dart';
import 'package:connect_with/models/user/user.dart';
import 'package:connect_with/providers/current_user_provider.dart';
import 'package:connect_with/providers/general_provider.dart';
import 'package:connect_with/providers/organization_provider.dart';
import 'package:provider/provider.dart';

class GraphProvider extends ChangeNotifier {

  HashMap<GraphNode, List<GraphEdge>> adjList = HashMap();

  AppUser targetUser = AppUser();
  Organization targetOrganization = Organization();

  List<AppUser> users = [];
  List<PostModel> posts = [];
  List<HashTagsModel> hashtags = [];
  List<Organization> organizations = [];

  /// **Fetch all data from Firebase**
  Future<void> fetchData(BuildContext context) async {
    try {
      users = await UserProfile.getUsers();
      organizations = await OrganizationProfile.getOrganizations();
      hashtags = await PostApis.getHashTags();
      posts = await PostApis.getAllPosts();

      final generalProvider =
      Provider.of<GeneralProvider>(context, listen: false);
      await generalProvider.checkUser();

      if (generalProvider.isOrganization) {
        final organizationProvider =
        Provider.of<OrganizationProvider>(context, listen: false);
        targetOrganization = organizationProvider.organization ?? Organization();
      } else {
        final appUserProvider =
        Provider.of<AppUserProvider>(context, listen: false);
        targetUser = appUserProvider.user ?? AppUser();
      }
    } catch (e) {
      print("Error while fetching all data in GraphProvider: $e");
    }
  }

  /// **Create Directed Graph (Adjacency List)**
  Future<void> createGraph(BuildContext context) async {

    await fetchData(context);
    adjList.clear();

    void addEdge(GraphNode from, GraphNode to, EdgeType type) {
      if (!adjList.containsKey(from)) {
        adjList[from] = [];
      }

      bool edgeExists = adjList[from]!.any((edge) => edge.to == to && edge.type == type);
      if (!edgeExists) {
        adjList[from]!.add(GraphEdge(from, to, type));
      }

    }

    for (var user in users) {

      GraphNode userNode = GraphNode(user.userID ?? "",NodeType.USER);

      for (var follower in user.followers ?? []) {

        bool isFollowerOrg = await AuthApi.userExistsById(follower, true);

        GraphNode followerNode = GraphNode(follower,isFollowerOrg ? NodeType.ORGANIZATION : NodeType.USER);
        addEdge(followerNode, userNode, EdgeType.FOLLOWS);
      }

      for (var followedUser in user.following ?? []) {

        bool isFollowedOrg = await AuthApi.userExistsById(followedUser, true);

        GraphNode followedUserNode = GraphNode(followedUser,isFollowedOrg ? NodeType.ORGANIZATION : NodeType.USER);
        addEdge(userNode, followedUserNode, EdgeType.FOLLOWS);
      }

      for (var followedOrg in user.organizations ?? []) {
        GraphNode orgNode = GraphNode(followedOrg,NodeType.ORGANIZATION);
        addEdge(userNode, orgNode, EdgeType.FOLLOWS_ORG);
      }
    }

    for (var org in organizations) {

      GraphNode orgNode = GraphNode(org.organizationId ?? "", NodeType.ORGANIZATION);

      for (var follower in org.followers ?? []) {

        bool isFollowerOrg = await AuthApi.userExistsById(follower, true);

        GraphNode followerNode = GraphNode(follower,isFollowerOrg ? NodeType.ORGANIZATION : NodeType.USER);
        addEdge(followerNode, orgNode, EdgeType.FOLLOWS);
      }

      for (var followedUser in org.followings ?? []) {

        bool isFollowedOrg = await AuthApi.userExistsById(followedUser, true);

        GraphNode followedUserNode = GraphNode(followedUser, isFollowedOrg ? NodeType.ORGANIZATION: NodeType.USER);
        addEdge(orgNode, followedUserNode, EdgeType.FOLLOWS);
      }

      for (var employee in org.employees ?? []) {
        GraphNode employeeNode = GraphNode(employee,NodeType.USER);
        addEdge(employeeNode, orgNode, EdgeType.WORKS_AT);
      }
    }

    for (var hashtag in hashtags) {
      GraphNode hashtagNode = GraphNode(hashtag.id ?? "",NodeType.HASHTAG);

      for (var follower in hashtag.followers ?? []) {

        bool isFollowerOrg = await AuthApi.userExistsById(follower, true);

        GraphNode userNode = GraphNode(follower,isFollowerOrg ? NodeType.ORGANIZATION :NodeType.USER);
        addEdge(userNode, hashtagNode, EdgeType.FOLLOWS_HASHTAG);
      }

      for (var post in hashtag.posts ?? []) {
        GraphNode postNode = GraphNode(post,NodeType.POST);
        addEdge(postNode, hashtagNode, EdgeType.HAS_HASHTAG);
      }

    }

    for (var post in posts) {
      GraphNode postNode = GraphNode(post.postId ?? "", NodeType.POST);

      if (post.userId != null) {

        bool isCreaterOrg = await AuthApi.userExistsById(post.userId ?? "", true);

        GraphNode userNode = GraphNode(post.userId!,isCreaterOrg ? NodeType.ORGANIZATION : NodeType.USER);
        addEdge(userNode, postNode, EdgeType.POSTED);
      }

      for (var likedBy in post.likes?.keys ?? []) {

        bool isLikeOrg = await AuthApi.userExistsById(likedBy.toString() , true);

        GraphNode likerNode = GraphNode(likedBy.toString(),isLikeOrg ? NodeType.ORGANIZATION : NodeType.USER);
        addEdge(likerNode, postNode, EdgeType.LIKED);
      }

      for (var commentEntry in (post.comments?.entries ?? {}.entries)) {
        if (commentEntry.key == null || commentEntry.value == null) continue;

        String commentId = commentEntry.key.toString();
        Comment comment = commentEntry.value;
        GraphNode commentNode = GraphNode(commentId,NodeType.COMMENT);

        if (comment.userId != null) {

          bool isCreaterOrg = await AuthApi.userExistsById(comment.userId?? "", true);

          GraphNode commenterNode = GraphNode(comment.userId!,isCreaterOrg ?NodeType.ORGANIZATION : NodeType.USER);
          addEdge(commenterNode, postNode, EdgeType.COMMENTED);
        }

        for (var likedBy in (comment.likes?.keys ?? {})) {

          bool isLikeByOrg = await AuthApi.userExistsById(likedBy.toString(), true);

          GraphNode likerNode = GraphNode(likedBy.toString(),isLikeByOrg ? NodeType.ORGANIZATION : NodeType.USER);
          addEdge(likerNode, commentNode, EdgeType.LIKED);
        }
      }
    }

    // printGraph();
    notifyListeners();
  }

  void printGraph() {
    print("\nGraph Adjacency List:");
    print("--------------------------------------------------");
    print("| Node (ID:Type)         | Connected To (Relation) |");
    print("--------------------------------------------------");
    adjList.forEach((key, value) {
      for (var edge in value) {
        print("| ${key.nid} (${key.type}) →  (${edge.type} -> ${edge.to.nid} (${edge.to.type}))");
      }
    });
    print("--------------------------------------------------");
  }
}
