import 'package:flutter/material.dart';

class CompanyJob {
  String? companyId;
  String? companyName;
  String? jobTitle;
  String? applyLink;
  String? location;
  String? experienceLevel;
  String? locationType;
  DateTime? postDate;
  bool? jobOpen;
  String? employmentType;
  int? applications;
  List<String>? applicants;
  String? about;
  List<String>? requirements;
  double? salary;

  CompanyJob({
    this.companyId,
    this.experienceLevel,
    this.companyName,
    this.jobTitle,
    this.applyLink,
    this.location,
    this.locationType,
    this.postDate,
    this.employmentType,
    this.jobOpen,
    this.applications,
    this.applicants,
    this.about,
    this.requirements,
    this.salary,
  });

  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'companyName': companyName,
      'jobTitle': jobTitle,
      'jobOpen' : jobOpen,
      'applyLink': applyLink,
      'location': location,
      'experienceLevel':experienceLevel,
      'locationType': locationType,
      'postDate': postDate?.toIso8601String(),
      'employmentType': employmentType,
      'applications': applications,
      'applicants': applicants,
      'about': about,
      'requirements': requirements,
      'salary': salary,
    };
  }

  factory CompanyJob.fromJson(dynamic json) {
    return CompanyJob(
      jobOpen : json['jobOpen'],
      companyId: json['companyId'],
      companyName: json['companyName'],
      jobTitle: json['jobTitle'],
      experienceLevel:json['experienceLevel'],
      applyLink: json['applyLink'],
      location: json['location'],
      locationType: json['locationType'],
      postDate: json['postDate'] != null
          ? DateTime.parse(json['postDate'])
          : null,
      employmentType: json['employmentType'],
      applications: json['applications'],
      applicants: (json['applicants'] as List<dynamic>?)?.map((e) => e as String).toList(),
      about: json['about'],
      requirements: (json['requirements'] as List<dynamic>?)?.map((e) => e as String).toList(),
      salary: json['salary'] != null ? json['salary'].toDouble() : null,
    );
  }
}
