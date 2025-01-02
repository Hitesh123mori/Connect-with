class CustomButton {
  bool? display;
  String? link;
  String? linkText;

  CustomButton({
    this.display,
    this.link,
    this.linkText,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['display'] = display;
    map['link'] = link;
    map['linkText'] = linkText;

    return map;
  }

  factory CustomButton.fromJson(dynamic json) {
    return CustomButton(
      display: json['display'],
      link: json['link'],
      linkText: json['linkText'],
    );
  }
}