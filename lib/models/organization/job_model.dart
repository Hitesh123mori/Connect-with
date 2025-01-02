import 'package:flutter/material.dart';

class CompanyJob {
  String? companyId;
  String? companyName;
  String? jobTitle;
  String? applyLink;
  String? location;
  String? locationType;
  String? postDate;
  String? employmentType;
  int? applications;
  List<String>? applicants;
  String? about;
  List<String>? requirements;
  double? salary;

  CompanyJob({
    this.companyId,
    this.companyName,
    this.jobTitle,
    this.applyLink,
    this.location,
    this.locationType,
    this.postDate,
    this.employmentType,
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
      'applyLink': applyLink,
      'location': location,
      'locationType': locationType,
      'postDate': postDate,
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
      companyId: json['companyId'],
      companyName: json['companyName'],
      jobTitle: json['jobTitle'],
      applyLink: json['applyLink'],
      location: json['location'],
      locationType: json['locationType'],
      postDate: json['postDate'],
      employmentType: json['employmentType'],
      applications: json['applications'],
      applicants: (json['applicants'] as List<dynamic>?)?.map((e) => e as String).toList(),
      about: json['about'],
      requirements: (json['requirements'] as List<dynamic>?)?.map((e) => e as String).toList(),
      salary: json['salary'],
    );
  }
}
