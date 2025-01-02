class Course {
  String? name;
  String? certificate;

  Course({
    this.name,
    this.certificate,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['certificate'] = certificate;

    return map;
  }

  factory Course.fromJson(dynamic json) {
    return Course(
      name: json['name'],
      certificate: json['certificate'],
    );
  }
}

class LicenseAndCertificate {
  String? name;
  String? issuingOrganization;
  String? issueDate;
  String? expirationDate;
  List<String>? skills;
  String? image;

  LicenseAndCertificate({
    this.name,
    this.issuingOrganization,
    this.issueDate,
    this.expirationDate,
    this.skills,
    this.image,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['issuingOrganization'] = issuingOrganization;
    map['issueDate'] = issueDate;
    map['expirationDate'] = expirationDate;
    map['skills'] = skills;
    map['image'] = image;

    return map;
  }

  factory LicenseAndCertificate.fromJson(dynamic json) {
    return LicenseAndCertificate(
      name: json['name'],
      issuingOrganization: json['issuingOrganization'],
      issueDate: json['issueDate'],
      expirationDate: json['expirationDate'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      image: json['image'],
    );
  }
}