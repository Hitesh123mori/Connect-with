class TestScores {

  String? title;
  String? score;
  String? testDate;
  String? description;
  String? id;

  TestScores({
    this.id,
    this.title,
    this.score,
    this.testDate,
    this.description,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['score'] = score;
    map['id']  = id ;
    map['testDate'] = testDate;
    map['description'] = description;

    return map;
  }

  factory TestScores.fromJson(dynamic json) {
    return TestScores(
      title: json['title'],
      score: json['score'],
      id : json['id'],
      testDate: json['testDate'],
      description: json['description'],
    );
  }
}