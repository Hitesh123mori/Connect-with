

class ContactInfo {
  String? phoneNumber;
  String? address;
  String? email;
  String? website;

  ContactInfo({
    this.phoneNumber,
    this.address,
    this.email,
    this.website,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phoneNumber'] = phoneNumber;
    map['address'] = address;
    map['email'] = email;
    map['website'] = website;

    return map;
  }

  factory ContactInfo.fromJson(dynamic json) {
    return ContactInfo(
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      email: json['email'],
      website: json['website'] ,
    );
  }
}