import 'package:connect_with/graph_alogrithms/init/graph_node.dart';
import 'package:connect_with/models/common/address_info.dart';
import 'package:connect_with/models/user/user.dart';

class Organization extends GraphNode{
  String? organizationId;
  String? name;
  String? email;
  String? domain;
  String? latestNews;
  String? coverPath;
  String? logo;
  Address? address;
  List<Views>? searchCount;
  List<Views>? profileView;
  List<String>? employees;
  List<String>? followers;
  List<String>? followings;
  String? about;
  String? website;
  String? companySize;
  String? ctype;
  List<String>? services;
  String? createAt;
  List<String>? jobs;
  bool? isOrganization;

  Organization({
    this.organizationId,
    this.name,
    this.jobs,
    this.email,
    this.domain,
    this.createAt,
    this.isOrganization,
    this.coverPath,
    this.latestNews,
    this.profileView,
    this.searchCount,
    this.logo,
    this.address,
    this.followers,
    this.employees,
    this.about,
    this.website,
    this.companySize,
    this.ctype,
    this.services,
    this.followings,
  }): super(organizationId ?? "", NodeType.ORGANIZATION);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['organizationId'] = organizationId;
    map['name'] = name;
    map['isOrganization'] = isOrganization;
    map['latestNews'] = latestNews;
    if (searchCount != null) {
      map['searchCount'] = searchCount!.map((e) => e.toJson()).toList();
    }

    if (profileView != null) {
      map['profileViews'] = profileView!.map((e) => e.toJson()).toList();
    }

    map['email'] = email;
    map['createAt'] = createAt;
    map['domain'] = domain;
    map['coverPath'] = coverPath;
    map['logo'] = logo;
    if (address != null) {
      map['address'] = address!.toJson();
    }
    map['followers'] = followers;
    map['followings'] = followings;
    if (employees != null) {
      map['employees'] = employees;
    }
    map['about'] = about;
    map['website'] = website;
    map['companySize'] = companySize;
    map['ctype'] = ctype;
    if (services != null) {
      map['services'] = services;
    }
    if (jobs != null) {
      map['jobs'] = jobs;
    }
    return map;
  }

  factory Organization.fromJson(dynamic json) {
    return Organization(
      organizationId: json['organizationId'],
      name: json['name'],
      isOrganization: json['isOrganization'],
      latestNews: json['latestNews'],

      profileView: (json['profileView'] is List)
          ? (json['profileView'] as List).map((e) {
        if (e is Map<String, dynamic>) {
          return Views.fromJson(e);
        } else {
          return Views(userID: e.toString());
        }
      }).toList()
          : [],
      searchCount: (json['searchCount'] is List)
          ? (json['searchCount'] as List).map((e) {
        if (e is Map<String, dynamic>) {
          return Views.fromJson(e);
        } else {
          return Views(userID: e.toString());
        }
      }).toList()
          : [],
      email: json['email'],
      domain: json['domain'],
      createAt: json['createAt'],
      coverPath: json['coverPath'],
      logo: json['logo'],
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      employees: json['employees'] != null ? List<String>.from(json['employees']) : null,
      followers: json['followers'] != null ? List<String>.from(json['followers']) : null,
      followings: json['followings'] != null ? List<String>.from(json['followings']) : null,
      about: json['about'],
      website: json['website'],
      companySize: json['companySize'],
      ctype: json['ctype'],
      services: json['services'] != null ? List<String>.from(json['services']) : null,
      jobs: json['jobs'] != null ? List<String>.from(json['jobs']) : null,
    );
  }
}
