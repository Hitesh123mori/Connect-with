class Education {

  String? schoolId;
  String? id;
  String? fieldOfStudy;
  String? startDate;
  String? endDate;
  String? grade;
  String? location ;
  String? description;
  List<String>? skills;
  String? media;

  Education({
    this.schoolId,
    this.fieldOfStudy,
    this.startDate,
    this.endDate,
    this.grade,
    this.id,
    this.description,
    this.skills,
    this.location,
    this.media,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['schoolId'] = schoolId;
    map['location'] = location;
    map['id'] = id;
    map['fieldOfStudy'] = fieldOfStudy;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['grade'] = grade;
    map['description'] = description;
    map['skills'] = skills;
    map['media'] = media;

    return map;
  }

  factory Education.fromJson(dynamic json) {
    return Education(
      schoolId: json['schoolId'],
      fieldOfStudy: json['fieldOfStudy'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      grade: json['grade'],
      location:json['location'],
      id : json['id'],
      description: json['description'],
      skills: json['skills'].cast<String>(),
      media: json['media'],
    );
  }
}