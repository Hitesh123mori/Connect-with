class SpeakLanguage {
  String? name;
  String? proficiency;


  SpeakLanguage({
    this.name,
    this.proficiency,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['proficiency'] = proficiency;

    return map;
  }

  factory SpeakLanguage.fromJson(dynamic json) {
    return SpeakLanguage(
      name: json['name'],
      proficiency: json['proficiency'],
    );
  }
}