class Project {

  String? proID;
  String? name;
  String? description;
  String? url;
  List<String>? skills;
  String? coverImage;
  String? startDate;
  String? endDate;
  List<String>? contributors;

  Project({
    this.proID,
    this.name,
    this.description,
    this.url,
    this.coverImage,
    this.startDate,
    this.endDate,
    this.contributors,
    this.skills,
  });

  Map<String, dynamic> toJson() {
    return {
      'proID': proID,
      'name': name,
      'description': description,
      'url': url,
      'coverImage': coverImage,
      'startDate': startDate,
      'endDate': endDate,
      'contributors': contributors,
      'skills': skills,
    };
  }

  factory Project.fromJson(dynamic json) {
    return Project(
      proID: json['proID'],
      name: json['name'],
      description: json['description'],
      url: json['url'],
      coverImage: json['coverImage'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      contributors: json['contributors'] != null
          ? List<String>.from(json['contributors'])
          : null,
      skills: json['skills'] != null
          ? List<String>.from(json['skills'])
          : null,
    );
  }
}
