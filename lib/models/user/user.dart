import 'package:connect_with/models/user/contact_info.dart';
import 'package:connect_with/models/user/course_and_liecence.dart';
import 'package:connect_with/models/common/custom_button.dart';
import 'package:connect_with/models/user/education.dart';
import 'package:connect_with/models/user/experience.dart';
import 'package:connect_with/models/user/project.dart';
import 'package:connect_with/models/user/skills.dart';
import 'package:connect_with/models/user/speak_language.dart';
import 'package:connect_with/models/user/test_score.dart';
import '../common/address_info.dart';

class AppUser {
  String? userID;
  String? email;
  bool? showProject;
  bool?showScore;
  bool? isOrganization ;
  bool? showEducation;
  bool? showSkill;
  String? userName;
  String? pronoun;
  bool? showLanguage;
  String? profilePath;
  String? coverPath;
  String? headLine;
  bool?showExperience;
  Address? address;
  String? about;
  int? followers;
  int? following;
  int? profileViews;
  int? searchCount;
  List<TestScores>? testScores;
  List<Skill>? skills;
  List<Project>? projects;
  List<SpeakLanguage>? language;
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
    this.language,
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
    map['showSkill']=showSkill;
    map['showEducation'] =showEducation;
    map['showExperience'] = showExperience;
    map['showLanguage']=showLanguage;
    map['isOrganization'] = isOrganization;
    map['email'] = email;
    map['showProject']=showProject;
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
    map['profileViews'] = profileViews;
    map['searchCount'] = searchCount;
    map['showExperience']=showExperience;
    if (testScores != null) {
      map['testScores'] = testScores!.map((e) => e.toJson()).toList();
    }
    if (skills != null) {
      map['skills'] = skills!.map((e) => e.toJson()).toList();
    }
    if (projects != null) {
      map['projects'] = projects!.map((e) => e.toJson()).toList();
    }
    if (language != null) {
      map['languages'] = language!.map((e) => e.toJson()).toList();
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
    return AppUser(
      userID: json['userID'],
      showEducation:json['showEducation'],
      showProject:json['showProject'],
      showExperience:json['showExperience'],
      isOrganization : json['isOrganization'],
      email: json['email'],
      showScore:json['showScore'],
      showSkill:json['showSkill'],
      userName: json['userName'],
      showLanguage:json['showLanguage'],
      pronoun: json['pronoun'],
      profilePath: json['profilePath'],
      coverPath: json['coverPath'],
      headLine: json['headLine'],
      createAt: json['create-at'],
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      about: json['about'],
      followers: json['followers'],
      following: json['following'],
      profileViews: json['profileViews'],
      searchCount: json['searchCount'],
      info: json['info'] != null ? ContactInfo.fromJson(json['info']) : null,
      button: json['button'] != null ? CustomButton.fromJson(json['button']) : null,
      testScores: json['testScores'] != null
          ? (json['testScores'] as List)
          .map((e) => TestScores.fromJson(e))
          .toList()
          : null,
      skills: json['skills'] != null
          ? (json['skills'] as List).map((e) => Skill.fromJson(e)).toList()
          : [],
      projects: json['projects'] != null
          ? (json['projects'] as List).map((e) => Project.fromJson(e)).toList()
          : [],
      language: json['language'] != null
          ? (json['language'] as List).map((e) => SpeakLanguage.fromJson(e)).toList()
          : [],
      experiences: json['experiences'] != null
          ? (json['experiences'] as List).map((e) => Experience.fromJson(e)).toList()
          : [],
      educations: json['educations'] != null
          ? (json['educations'] as List).map((e) => Education.fromJson(e)).toList()
          : [],
      lacertificate: json['lacertificate'] != null
          ? (json['lacertificate'] as List)
          .map((e) => LicenseAndCertificate.fromJson(e))
          .toList()
          : [],
    );
  }
}
