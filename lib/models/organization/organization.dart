import 'package:connect_with/models/common/address_info.dart';
import 'package:connect_with/models/common/custom_button.dart';

class Organization {
  String? organizationId;
  String? name;
  String? email;
  String? domain;
  String? coverPath;
  String? logo;
  Address? address;
  int? followers;
  int? searchCount;
  int? profileView;
  List<String>? employees;
  CustomButton? button;
  String? about;
  String? website;
  String? companySize;
  String? type;
  List<String>? services;
  String? createAt;
  List<String>? jobs;

  Organization({
    this.organizationId,
    this.name,
    this.jobs,
    this.email,
    this.domain,
    this.createAt,
    this.coverPath,
    this.profileView,
    this.searchCount,
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
    map['profileView'] = profileView ;
    map['searchCount'] = searchCount ;
    map['email'] = email;
    map['createAt'] = createAt;
    map['domain'] = domain;
    map['coverPath'] = coverPath;
    map['logo'] = logo;
    if (address != null) {
      map['address'] = address!.toJson();
    }
    map['followers'] = followers;
    if (employees != null) {
      map['employees'] = employees;
    }
    if (button != null) {
      map['button'] = button!.toJson();
    }
    map['about'] = about;
    map['website'] = website;
    map['companySize'] = companySize;
    map['type'] = type;
    if (services != null) {
      map['services'] = services;
    }
    if (jobs != null) {
      map['jobs'] = jobs;
    }
    return map;
  }

  // Create an Organization object from JSON
  factory Organization.fromJson(dynamic json) {
    return Organization(
      organizationId: json['organizationId'],
      name: json['name'],
      searchCount : json['searchCount'],
      profileView: json['profileView'],
      email: json['email'],
      domain: json['domain'],
      createAt: json['createAt'],
      coverPath: json['coverPath'],
      logo: json['logo'],
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      followers: json['followers'],
      employees: json['employees'] != null
          ? List<String>.from(json['employees'])
          : null,
      button: json['button'] != null ? CustomButton.fromJson(json['button']) : null,
      about: json['about'],
      website: json['website'],
      companySize: json['companySize'],
      type: json['type'],
      services: json['services'] != null ? List<String>.from(json['services']) : null,
      jobs: json['jobs'] != null ? List<String>.from(json['jobs']) : null,
    );
  }
}
