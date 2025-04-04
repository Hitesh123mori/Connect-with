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
import 'dart:math';


class GraphProvider extends ChangeNotifier {

  HashMap<GraphNode, List<GraphEdge>> adjList = HashMap();

  List<String> suggestedPosts = [];
  List<String> suggestedUsers = [] ;

  AppUser targetUser = AppUser();
  Organization targetOrganization = Organization();

  List<AppUser> users = [];
  List<PostModel> posts = [];
  List<HashTagsModel> hashtags = [];
  List<Organization> organizations = [];

  /// Fetch all data from Firebase**
  Future<void> fetchData(BuildContext context) async {
    try {
      users = await UserProfile.getUsers();
      organizations = await OrganizationProfile.getOrganizations();
      hashtags = await PostApis.getHashTags();
      posts = await PostApis.getAllPosts();

      final generalProvider = Provider.of<GeneralProvider>(context, listen: false);
      await generalProvider.checkUser();

      if (generalProvider.isOrganization) {
        final organizationProvider = Provider.of<OrganizationProvider>(context, listen: false);
        targetOrganization = organizationProvider.organization ?? Organization();
      } else {
        final appUserProvider = Provider.of<AppUserProvider>(context, listen: false);
        targetUser = appUserProvider.user ?? AppUser();

      }
    } catch (e) {
      print("Error while fetching all data in GraphProvider: $e");
    }
  }

  /// Create Directed Graph (Adjacency List)
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


    /// friends recommendations
    jaccardSimilarity() ;
    bfsFriendSuggestions();
    louvainCommunityDetection() ;
    suggestFriendsAdamicAdar();
    suggestFriendsBridgingCentrality(GraphNode(targetUser.userID ?? "", NodeType.USER),louvainCommunityDetection());
    suggestFriendsHashTagJaccardSimilarity() ;

    suggestedUsers = suggestedUsers.toSet().toList();
    // print(suggestedUsers);


    ///posts
    recommendPostsByHashtags();
    recommendPostsByUserInteraction();

    print(suggestedPosts) ;
    print(suggestedUsers) ;


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




  /// algorithm for friend recommendations :

  void jaccardSimilarity() async {

    Map<GraphNode, double> similarityScores = {};

    GraphNode targetNode = GraphNode(targetUser.userID ?? "", NodeType.USER);
    Set<GraphNode> targetNeighbors = {};

    if (adjList.keys.contains(targetNode)) {
      targetNeighbors = adjList[targetNode]!.map((edge) => edge.to).toSet();
    }

    for (var entry in adjList.entries) {
      GraphNode userNode = entry.key;

      if (userNode == targetNode || targetNeighbors.contains(userNode)) {
        continue;
      }

      Set<GraphNode> userNeighbors = {};

      if (adjList.containsKey(userNode)) {
        userNeighbors = adjList[userNode]!.map((edge) => edge.to).toSet();
      }

      Set<GraphNode> intersection = targetNeighbors.intersection(userNeighbors);
      Set<GraphNode> union = targetNeighbors.union(userNeighbors);

      double jaccardScore = (union.isNotEmpty) ? intersection.length / union.length : 0.0;
      similarityScores[userNode] = jaccardScore;

      if (jaccardScore >= 0.5) {
        suggestedUsers.add(userNode.nid);
      }
    }

  }

  void bfsFriendSuggestions() {
    if (targetUser.userID == null || targetUser.userID!.isEmpty) {
      print("No target user set for BFS suggestion.");
      return;
    }

    GraphNode startNode = GraphNode(targetUser.userID!, NodeType.USER);
    Set<GraphNode> visited = {};
    Queue<GraphNode> queue = Queue();
    List<GraphNode> suggestions = [];

    queue.add(startNode);
    visited.add(startNode);

    while (queue.isNotEmpty) {
      GraphNode currentNode = queue.removeFirst();

      if (adjList.containsKey(currentNode)) {
        for (GraphEdge edge in adjList[currentNode]!) {
          GraphNode neighbor = edge.to;

          if (!visited.contains(neighbor)) {
            queue.add(neighbor);
            visited.add(neighbor);

            if (neighbor.type == NodeType.USER || neighbor.type == NodeType.ORGANIZATION) {
              suggestions.add(neighbor);
            }
          }
        }
      }
    }

    suggestions.removeWhere((node) => adjList[startNode]?.any((edge) => edge.to == node) ?? false);
    suggestedUsers = suggestions.map((node) => node.nid).toList();

  }
  void suggestFriendsAdamicAdar() {
    GraphNode startNode = GraphNode(targetUser.userID ?? "", NodeType.USER);
    Set<GraphNode> directFriends = {};
    Map<GraphNode, double> similarityScore = {};

    // Get direct friends of target user
    if (adjList.containsKey(startNode)) {
      for (GraphEdge edge in adjList[startNode]!) {
        directFriends.add(edge.to);
      }
    }

    // Find second-degree friends
    for (var friend in directFriends) {
      if (adjList.containsKey(friend)) {
        for (GraphEdge edge in adjList[friend]!) {
          GraphNode potentialFriend = edge.to;

          if (potentialFriend == startNode || directFriends.contains(potentialFriend)) {
            continue;
          }

          // Compute Adamic-Adar index
          double score = 0.0;
          for (var mutualFriend in directFriends) {
            int degree = adjList[mutualFriend]?.length ?? 1;
            score += 1 / (degree > 1 ? log(degree) : 1);
          }

          similarityScore[potentialFriend] = (similarityScore[potentialFriend] ?? 0) + score;
        }
      }
    }

    List<MapEntry<GraphNode, double>> sortedSuggestions = similarityScore.entries.toList();
    sortedSuggestions.sort((a, b) => b.value.compareTo(a.value));

    // print("\n Suggested Friends for ${targetUser.userID} Using Adamic-Adar Index:");
    for (var entry in sortedSuggestions) {
      // print("${entry.key.nid}: Score ${entry.value.toStringAsFixed(2)}");

      if (entry.value >= 0.5) {
        suggestedUsers.add(entry.key.nid);
      }
    }

  }


  Map<GraphNode, int> louvainCommunityDetection() {
    Map<GraphNode, int> community = {};
    int communityId = 0;

    for (var node in adjList.keys) {
      community[node] = communityId++;
    }

    bool improvement = true;
    while (improvement) {
      improvement = false;
      for (var node in adjList.keys) {
        Map<int, double> neighborCommunities = {};

        for (var edge in adjList[node]!) {
          int? neighborCommunity = community[edge.to ?? ""] ;
          neighborCommunities[neighborCommunity ?? 0] =
              (neighborCommunities[neighborCommunity] ?? 0) + 1;
        }

        int bestCommunity = community[node]!;
        double bestGain = 0;
        for (var entry in neighborCommunities.entries) {
          double gain = entry.value;
          if (gain > bestGain) {
            bestGain = gain;
            bestCommunity = entry.key;
          }
        }

        if (bestCommunity != community[node]) {
          community[node] = bestCommunity;
          improvement = true;
        }
      }
    }

    // print("\n Detected Communities:");
    Map<int, List<String>> communityGroups = {};
    for (var entry in community.entries) {
      communityGroups.putIfAbsent(entry.value, () => []).add(entry.key.nid);
    }

    // for (var entry in communityGroups.entries) {
    //   print("Community ${entry.key}: ${entry.value.join(', ')}");
    // }

    return community;
  }
  void suggestFriendsBridgingCentrality(GraphNode targetUser, Map<GraphNode, int> community) {
    int targetCommunity = community[targetUser] ?? -1;
    Map<GraphNode, int> bridgingScores = {};

    // Step 1: Find the most connected users from other communities
    for (var node in community.keys) {
      if (community[node] != targetCommunity) {
        int connections = adjList[node]?.length ?? 0;
        bridgingScores[node] = connections;
      }
    }

    // Step 2: Sort potential friends based on bridging score
    List<MapEntry<GraphNode, int>> sortedBridgingUsers = bridgingScores.entries.toList();
    sortedBridgingUsers.sort((a, b) => b.value.compareTo(a.value));

    // Step 3: Suggest the top bridging user
    // print("\ Suggested Friend to Strengthen Network:");
    if (sortedBridgingUsers.isNotEmpty) {
      GraphNode bestFriendSuggestion = sortedBridgingUsers.first.key;
      // print(" Suggested Friend: ${bestFriendSuggestion.nid}");
      suggestedUsers.add(bestFriendSuggestion.nid) ;
    } else {
      print("No cross-community friends found.");
    }
  }


  // hashtag jaccard similarity
  Set<String> extractUserHashtags(GraphNode user) {

     Set<String> userHashtags = {};

    adjList.forEach((GraphNode node, List<GraphEdge> edges) {
      if (node==user) {
        for (var edge in edges) {
          if (edge.type == EdgeType.FOLLOWS_HASHTAG) {
            userHashtags.add(edge.to.nid);
          }
        }
      }
    });

    return userHashtags;
  }
  double computeJaccardSimilarity(Set<String> setA, Set<String> setB) {
    if (setA.isEmpty || setB.isEmpty) return 0.0;

    Set<String> intersection = setA.intersection(setB);
    Set<String> union = setA.union(setB);

    return intersection.length / union.length;
  }
  void suggestFriendsHashTagJaccardSimilarity() {

    Map<String, double> similarityScores = {};

    GraphNode tUser = GraphNode(targetUser.userID ?? "" ,NodeType.USER) ;

    Set<String> targetUserHashTags = extractUserHashtags(tUser) ;

    for(var user in users){

      if(adjList[tUser]!.contains(user) || user!=targetUser){
        continue;
      }

      Set<String> userHashTags = extractUserHashtags(GraphNode(user.userID ?? "" ,NodeType.USER)) ;

      double similarity = computeJaccardSimilarity(targetUserHashTags, userHashTags);

      similarityScores[user.userID ?? ""] = similarity;

    }

    List<MapEntry<String, double>> sortedUsers = similarityScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // print("\nFriend Suggestions for $targetUser.userID:");
    // print(similarityScores) ;
    for (var entry in sortedUsers.take(5)) {
      suggestedUsers.add(entry.key) ;
      // print("User: ${entry.key}, Similarity Score: ${entry.value.toStringAsFixed(3)}");
    }
  }




  /// posts recommendations

  void recommendPostsByHashtags() {

    GraphNode targetUserNode = GraphNode(targetUser.userID ?? "", NodeType.USER);
    Set<String> userHashtags = {};

    if (adjList.containsKey(targetUserNode)) {
      for (GraphEdge edge in adjList[targetUserNode]!) {
        if (edge.type == EdgeType.FOLLOWS_HASHTAG) {
          userHashtags.add(edge.to.nid);
        }
      }
    }

    Set<String> relevantPosts = {};

    for (var entry in adjList.entries) {
      GraphNode postNode = entry.key;
      List<GraphEdge> edges = entry.value;

      for (GraphEdge edge in edges) {
        if (edge.type == EdgeType.HAS_HASHTAG && userHashtags.contains(edge.to.nid)) {
          relevantPosts.add(postNode.nid);
          break;
        }
      }
    }


    suggestedPosts = relevantPosts.toList();

  }


  void recommendPostsByUserInteraction() {

    GraphNode targetUserNode = GraphNode(targetUser.userID ?? "", NodeType.USER);
    Set<String> seenPosts = {};
    Set<String> recommendedPosts = {};

    if (adjList.containsKey(targetUserNode)) {
      for (GraphEdge edge in adjList[targetUserNode]!) {
        if (edge.type == EdgeType.LIKED || edge.type == EdgeType.COMMENTED || edge.type == EdgeType.POSTED) {
          seenPosts.add(edge.to.nid);
        }
      }
    }


    Set<GraphNode> similarUsers = {};

    for (AppUser user in users) {
      GraphNode userNode = GraphNode(user.userID ?? "", NodeType.USER);

      bool userInteractedWithSeenPost = false;

      if (adjList.containsKey(userNode)) {
        for (GraphEdge edge in adjList[userNode]!) {
          if (seenPosts.contains(edge.to.nid) &&
              (edge.type == EdgeType.LIKED || edge.type == EdgeType.COMMENTED)) {
            userInteractedWithSeenPost = true;
            break;
          }
        }
      }

      if (userInteractedWithSeenPost) {
         similarUsers.add(userNode) ;
      }
    }

    for (Organization organization in organizations) {
      GraphNode orgNode = GraphNode(organization.organizationId ?? "", NodeType.ORGANIZATION);

      bool userInteractedWithSeenPost = false;

      if (adjList.containsKey(orgNode)) {
        for (GraphEdge edge in adjList[orgNode]!) {
          if (seenPosts.contains(edge.to.nid) &&
              (edge.type == EdgeType.LIKED || edge.type == EdgeType.COMMENTED)) {
            userInteractedWithSeenPost = true;
            break;
          }
        }
      }

      if (userInteractedWithSeenPost) {
        similarUsers.add(orgNode) ;
      }
    }


    for (GraphNode user in similarUsers) {
      if (!adjList.containsKey(user)) continue;

      for (GraphEdge edge in adjList[user]!) {
        if ((edge.type == EdgeType.LIKED || edge.type == EdgeType.COMMENTED) &&
            !seenPosts.contains(edge.to.nid)) {
          recommendedPosts.add(edge.to.nid);
        }
      }
    }

    suggestedPosts.addAll(recommendedPosts);
  }

}

