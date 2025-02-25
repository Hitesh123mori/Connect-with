class HashTagsModel {
  String? id;
  String? name;
  List<String>? followers;
  List<String>? posts;

  HashTagsModel({
    this.id,
    this.name,
    this.followers,
    this.posts,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'followers': followers,
      'posts': posts,
    };
  }

  factory HashTagsModel.fromJson(Map<String, dynamic> json) {
    return HashTagsModel(
      id: json['id'],
      name: json['name'],
      followers: List<String>.from(json['followers'] ?? []),
      posts: List<String>.from(json['posts'] ?? []),
    );
  }
}
