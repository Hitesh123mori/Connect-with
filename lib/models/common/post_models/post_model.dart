
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
  List<String>? likes;
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
    this.likes,
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
    likes: json['likes'] != null ? List<String>.from(json['likes']) : null,
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
    'likes': likes,
    'repostCount': repostCount,
    'attachmentName': attachmentName,
    'time': time,
    'comments': comments?.map((x) => x.toJson()).toList(),
  };
}

class Comment {
  String? commentId;
  String? userId;
  String? postId;
  List<String>? likes;
  String? description;
  String? time;
  List<Comment>? comments;

  Comment({
    this.commentId,
    this.userId,
    this.postId,
    this.description,
    this.time,
    this.likes,
    this.comments,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    commentId: json['commentId'],
    userId: json['userId'],
    postId: json['postId'],
    description: json['description'],
    time: json['time'],
    likes: json['likes'] != null ? List<String>.from(json['likes']) : null,
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
    'time': time,
    'likes': likes,
    'comments': comments?.map((x) => x.toJson()).toList(),
  };
}
