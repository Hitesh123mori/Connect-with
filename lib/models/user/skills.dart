import 'package:connect_with/models/user/project.dart';

class Skill {
  String? name;
  List<String>? endorsedPeoples;
  List<String>? projects;

  Skill({
    this.name,
    this.endorsedPeoples,
    this.projects,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['endorsedPeoples'] = endorsedPeoples;
    map['projects'] = projects;

    return map;
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'],
      endorsedPeoples: json['endorsedPeoples'] != null
          ? List<String>.from(json['endorsedPeoples'])
          : null,
      projects:  json['projects'] != null
          ? List<String>.from(json['projects'])
          : null,
    );
  }
}
