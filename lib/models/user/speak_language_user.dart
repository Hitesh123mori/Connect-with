class SpeakLanguageUser{
  String? name;
  String? id;
  String? proficiency;


  SpeakLanguageUser({
    this.name,
    this.proficiency,
    this.id,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['id'] = id;
    map['proficiency'] = proficiency;

    return map;
  }

  factory SpeakLanguageUser.fromJson(dynamic json) {
    return SpeakLanguageUser(
      name: json['name'],
      id : json['id'],
      proficiency: json['proficiency'],
    );
  }
}