class SpeakLanguageUser{
  String? name;
  String? proficiency;


  SpeakLanguageUser({
    this.name,
    this.proficiency,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['proficiency'] = proficiency;

    return map;
  }

  factory SpeakLanguageUser.fromJson(dynamic json) {
    return SpeakLanguageUser(
      name: json['name'],
      proficiency: json['proficiency'],
    );
  }
}