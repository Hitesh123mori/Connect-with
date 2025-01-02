class Positions {
  String? title;
  String? location;
  String? startDate;
  String? endDate;
  String? description;
  List<String>? skills;
  String? media;

  Positions({
    this.title,
    this.location,
    this.startDate,
    this.endDate,
    this.description,
    this.skills,
    this.media,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'skills': skills,
      'media': media,
    };
  }

  factory Positions.fromJson(Map<String, dynamic> json) {
    return Positions(
      title: json['title'],
      location: json['location'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      description: json['description'],
      skills: (json['skills'] as List<dynamic>?)?.cast<String>(),
      media: json['media'],
    );
  }
}

class Experience {
  String? employementType;
  String? companyName;
  List<Positions>? positions;

  Experience({
    this.employementType,
    this.companyName,
    this.positions,
  });

  Map<String, dynamic> toJson() {
    return {
      'employementType': employementType,
      'companyName': companyName,
      'positions': positions?.map((position) => position.toJson()).toList(),
    };
  }

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      employementType: json['employementType'],
      companyName: json['companyName'],
      positions: (json['positions'] as List<dynamic>?)
          ?.map((position) => Positions.fromJson(position))
          .toList(),
    );
  }
}
