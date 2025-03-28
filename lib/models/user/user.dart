import 'package:connect_with/models/common/address_info.dart';
import 'package:connect_with/models/user/contact_info.dart';
import 'package:connect_with/models/user/course_and_liecence.dart';
import 'package:connect_with/models/common/custom_button.dart';
import 'package:connect_with/models/user/education.dart';
import 'package:connect_with/models/user/experience.dart';
import 'package:connect_with/models/user/project.dart';
import 'package:connect_with/models/user/skills.dart';
import 'package:connect_with/models/user/speak_language_user.dart';
import 'package:connect_with/models/user/test_score.dart';

class AppUser {
  String? userID;
  String? email;
  bool? showProject;
  bool? showScore;
  bool? isOrganization;
  bool? showEducation;
  bool? showSkill;
  String? userName;
  String? pronoun;
  bool? showLanguage;
  String? profilePath;
  String? coverPath;
  String? headLine;
  bool? showExperience;
  Address? address;
  String? about;
  List<String>? followers;
  List<String>? following;
  List<String>? organizations;
  List<String>? profileViews ;
  List<String>?searchCount;
  List<TestScores>? testScores;
  List<Skill>? skills;
  List<Project>? projects;
  List<SpeakLanguageUser>? languages;
  List<Experience>? experiences;
  List<Education>? educations;
  CustomButton? button;
  List<LicenseAndCertificate>? lacertificate;
  ContactInfo? info;
  String? createAt;

  AppUser({
    this.userID,
    this.email,
    this.showScore,
    this.showEducation,
    this.isOrganization,
    this.showLanguage,
    this.userName,
    this.pronoun,
    this.showSkill,
    this.showProject,
    this.showExperience,
    this.profilePath,
    this.organizations,
    this.coverPath,
    this.headLine,
    this.address,
    this.about,
    this.followers,
    this.following,
    this.profileViews,
    this.searchCount,
    this.testScores,
    this.skills,
    this.projects,
    this.languages,
    this.experiences,
    this.educations,
    this.button,
    this.lacertificate,
    this.info,
    this.createAt,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userID'] = userID;
    map['showSkill'] = showSkill;
    map['showEducation'] = showEducation;
    map['showExperience'] = showExperience;
    map['showLanguage'] = showLanguage;
    map['isOrganization'] = isOrganization;
    map['email'] = email;
    map['showProject'] = showProject;
    map['userName'] = userName;
    map['showScore'] = showScore;
    map['pronoun'] = pronoun;
    map['profilePath'] = profilePath;
    map['coverPath'] = coverPath;
    map['headLine'] = headLine;
    map['create-at'] = createAt;
    if (address != null) {
      map['address'] = address!.toJson();
    }
    map['about'] = about;
    map['followers'] = followers;
    map['following'] = following;
    map['organizations'] = organizations;
    map['profileViews'] = profileViews;
    map['searchCount'] = searchCount;
    if (testScores != null) {
      map['testScores'] = testScores!.map((e) => e.toJson()).toList();
    }
    if (skills != null) {
      map['skills'] = skills!.map((e) => e.toJson()).toList();
    }
    if (projects != null) {
      map['projects'] = projects!.map((e) => e.toJson()).toList();
    }
    if (languages != null) {
      map['languages'] = languages!.map((e) => e.toJson()).toList();
    }
    if (experiences != null) {
      map['experiences'] = experiences!.map((e) => e.toJson()).toList();
    }
    if (educations != null) {
      map['educations'] = educations!.map((e) => e.toJson()).toList();
    }
    if (lacertificate != null) {
      map['licensesAndCertificates'] = lacertificate!.map((e) => e.toJson()).toList();
    }
    if (info != null) {
      map['info'] = info!.toJson();
    }
    if (button != null) {
      map['button'] = button!.toJson();
    }
    return map;
  }

  factory AppUser.fromJson(dynamic json) {
    // print("JSON received: $json");
    return AppUser(
      userID: json['userID'],
      organizations: (json['organizations'] is List)
          ? (json['organizations'] as List).map((e) => e.toString()).toList()
          : [],
      showEducation: json['showEducation'],
      showProject: json['showProject'],
      showExperience: json['showExperience'],
      isOrganization: json['isOrganization'],
      email: json['email'],
      showScore: json['showScore'],
      showSkill: json['showSkill'],
      userName: json['userName'],
      showLanguage: json['showLanguage'],
      pronoun: json['pronoun'],
      profilePath: json['profilePath'],
      coverPath: json['coverPath'],
      headLine: json['headLine'],
      createAt: json['create-at'],
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      about: json['about'],
      followers: (json['followers'] is List)
          ? (json['followers'] as List).map((e) => e.toString()).toList()
          : [], // Ensure it's a list
      following: (json['following'] is List)
          ? (json['following'] as List).map((e) => e.toString()).toList()
          : [],
      profileViews: (json['profileViews'] is List)
          ? (json['profileViews'] as List).map((e) => e.toString()).toList()
          : [],
      searchCount: (json['searchCount'] is List)
          ? (json['searchCount'] as List).map((e) => e.toString()).toList()
          : [],
      info: json['info'] != null ? ContactInfo.fromJson(json['info']) : null,
      button: json['button'] != null ? CustomButton.fromJson(json['button']) : null,
      testScores: (json['testScores'] is List)
          ? (json['testScores'] as List).map((e) => TestScores.fromJson(e)).toList()
          : [],
      skills: (json['skills'] is List)
          ? (json['skills'] as List).map((e) => Skill.fromJson(e)).toList()
          : [],
      projects: (json['projects'] is List)
          ? (json['projects'] as List).map((e) => Project.fromJson(e)).toList()
          : [],
      languages: (json['languages'] is List)
          ? (json['languages'] as List).map((e) => SpeakLanguageUser.fromJson(e)).toList()
          : [],
      experiences: (json['experiences'] is List)
          ? (json['experiences'] as List).map((e) => Experience.fromJson(e)).toList()
          : [],
      educations: (json['educations'] is List)
          ? (json['educations'] as List).map((e) => Education.fromJson(e)).toList()
          : [],
      lacertificate: (json['licensesAndCertificates'] is List)
          ? (json['licensesAndCertificates'] as List).map((e) => LicenseAndCertificate.fromJson(e)).toList()
          : [],
    );
  }

}
