import 'dart:convert';

class PostModel {

  String? postId;
  String? userId;
  String? description;
  bool? hasImage;
  bool? hasPdf;
  bool? hasPoll;
  List<String>? imageUrls;
  String? pdfUrl;
  String? pollData;
  String? funnyCount;
  String? likeCount;
  String? clapCount;
  String? insightfulCount;
  String? heartCount;
  List<Reaction>? reactions;
  String? repostCount;
  String? attachmentName;
  String? time;
  List<Comment>? comments;

  PostModel({
    this.postId,
    this.userId,
    this.description,
    this.hasImage,
    this.hasPdf,
    this.hasPoll,
    this.imageUrls,
    this.pdfUrl,
    this.pollData,
    this.funnyCount,
    this.likeCount,
    this.clapCount,
    this.insightfulCount,
    this.heartCount,
    this.reactions,
    this.repostCount,
    this.attachmentName,
    this.time,
    this.comments,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    postId: json['postId'],
    userId: json['userId'],
    description: json['description'],
    hasImage: json['hasImage'],
    hasPdf: json['hasPdf'],
    hasPoll: json['hasPoll'],
    imageUrls: json['imageUrls'] != null
        ? List<String>.from(json['imageUrls'])
        : null,
    pdfUrl: json['pdfUrl'],
    pollData: json['pollData'],
    funnyCount: json['funnyCount'],
    likeCount: json['likeCount'],
    clapCount: json['clapCount'],
    insightfulCount: json['insightfulCount'],
    heartCount: json['heartCount'],
    reactions: json['reactions'] != null
        ? List<Reaction>.from(
        json['reactions'].map((x) => Reaction.fromJson(x)))
        : null,
    repostCount: json['repostCount'],
    attachmentName: json['attachmentName'],
    time: json['time'],
    comments: json['comments'] != null
        ? List<Comment>.from(
        json['comments'].map((x) => Comment.fromJson(x)))
        : null,
  );

  Map<String, dynamic> toJson() => {
    'postId': postId,
    'userId': userId,
    'description': description,
    'hasImage': hasImage,
    'hasPdf': hasPdf,
    'hasPoll': hasPoll,
    'imageUrls': imageUrls,
    'pdfUrl': pdfUrl,
    'pollData': pollData,
    'funnyCount': funnyCount,
    'likeCount': likeCount,
    'clapCount': clapCount,
    'insightfulCount': insightfulCount,
    'heartCount': heartCount,
    'reactions': reactions?.map((x) => x.toJson()).toList(),
    'repostCount': repostCount,
    'attachmentName': attachmentName,
    'time': time,
    'comments': comments?.map((x) => x.toJson()).toList(),
  };
}

class Reaction {
  String? userId;
  int? reactionIndex;

  Reaction({this.userId, this.reactionIndex});

  factory Reaction.fromJson(Map<String, dynamic> json) => Reaction(
    userId: json['userId'],
    reactionIndex: json['reactionIndex'],
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'reactionIndex': reactionIndex,
  };
}

class Comment {
  String? commentId;
  String? userId;
  String? postId;
  String? description;
  String? funnyCount;
  String? likeCount;
  String? clapCount;
  String? insightfulCount;
  String? heartCount;
  String? time;
  List<Comment>? comments;

  Comment({
    this.commentId,
    this.userId,
    this.postId,
    this.description,
    this.funnyCount,
    this.likeCount,
    this.clapCount,
    this.insightfulCount,
    this.heartCount,
    this.time,
    this.comments,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    commentId: json['commentId'],
    userId: json['userId'],
    postId: json['postId'],
    description: json['description'],
    funnyCount: json['funnyCount'],
    likeCount: json['likeCount'],
    clapCount: json['clapCount'],
    insightfulCount: json['insightfulCount'],
    heartCount: json['heartCount'],
    time: json['time'],
    comments: json['comments'] != null
        ? List<Comment>.from(
        json['comments'].map((x) => Comment.fromJson(x)))
        : null,
  );

  Map<String, dynamic> toJson() => {
    'commentId': commentId,
    'userId': userId,
    'postId': postId,
    'description': description,
    'funnyCount': funnyCount,
    'likeCount': likeCount,
    'clapCount': clapCount,
    'insightfulCount': insightfulCount,
    'heartCount': heartCount,
    'time': time,
    'comments': comments?.map((x) => x.toJson()).toList(),
  };
}
