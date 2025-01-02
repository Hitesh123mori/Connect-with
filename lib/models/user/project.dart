import 'package:connect_with/models/user/skills.dart';
import 'package:connect_with/models/user/user.dart';

class Project {

  String? proID;
  String? name;
  String? description;
  String? url;
  List<Skill>? skills;
  String? coverImage;
  String? startDate;
  String? endDate;
  List<AppUser>? contributors;

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
    final map = <String, dynamic>{};
    map['proID'] = proID;
    map['name'] = name;
    map['description'] = description;
    map['url'] = url;
    map['coverImage'] = coverImage;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['contributors'] = contributors?.map((e) => e.toJson()).toList();
    map['skills'] = skills?.map((e) => e.toJson()).toList();


    return map;
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
      contributors: json['contributors']!= null
          ? (json['contributors'] as List)
          .map((e) => AppUser.fromJson(e))
          .toList()
          : null,
      skills: json['skills']!= null
          ? (json['skills'] as List)
          .map((e) => Skill.fromJson(e))
          .toList()
          : null,
    );
  }
}