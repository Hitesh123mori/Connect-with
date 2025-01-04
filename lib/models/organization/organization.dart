import 'package:connect_with/models/common/address_info.dart';
import 'package:connect_with/models/common/custom_button.dart';
import 'package:connect_with/models/user/user.dart';

class Organization {
  String? organizationId;
  String? name;
  String? email;
  String? domain;
  String? coverPath;
  String? logo;
  Address? address;
  int? followers;
  List<AppUser>? employees;
  CustomButton? button;
  String? about;
  String? website;
  String? companySize;
  String? type;
  List<String>? services;
  String? createAt;


  Organization({
    this.organizationId,
    this.name,
    this.email,
    this.domain,
    this.createAt,
    this.coverPath,
    this.logo,
    this.address,
    this.followers,
    this.employees,
    this.button,
    this.about,
    this.website,
    this.companySize,
    this.type,
    this.services,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['organizationId'] = organizationId;
    map['name'] = name;
    map['email'] = email ;
    map['createAt'] = createAt ;
    map['domain'] = domain;
    map['coverPath'] = coverPath;
    map['logo'] = logo;
    if (address != null) {
      map['address'] = address!.toJson();
    }
    map['followers'] = followers;
    if (employees != null) {
      map['employees'] = employees!.map((e) => e.toJson()).toList();
    }
    if (button != null) {
      map['button'] = button!.toJson();
    }
    map['about'] = about;
    map['website'] = website;
    map['companySize'] = companySize;
    map['type'] = type;
    map['services'] = services;
    return map;
  }

  factory Organization.fromJson(dynamic json) {
    return Organization(
      organizationId: json['organizationId'],
      name: json['name'],
      email:json['email'],
      domain: json['domain'],
      createAt:json['createAt'],
      coverPath: json['coverPath'],
      logo: json['logo'],
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      followers: json['followers'],
      employees: json['employees'] != null
          ? (json['employees'] as List)
          .map((e) => AppUser.fromJson(e))
          .toList()
          : null,
      button: json['button'] != null
          ? CustomButton.fromJson(json['button'])
          : null,
      about: json['about'],
      website: json['website'],
      companySize: json['companySize'],
      type: json['type'],
      services: json['services'] != null
          ? List<String>.from(json['services'])
          : null,
    );
  }
}
