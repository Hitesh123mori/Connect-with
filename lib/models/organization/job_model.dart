import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompanyJob {

  String? companyId;
  String? jobId;
  String? companyName;
  String? jobTitle;
  bool? easyApply;
  String? applyLink;
  String? location;
  String? experienceLevel;
  String? locationType;
  String? postDate;
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
    this.jobId,
    this.postDate,
    this.employmentType,
    this.jobOpen,
    this.easyApply,
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
      'easyApply' :easyApply,
      'jobTitle': jobTitle,
      'jobId' :jobId,
      'jobOpen' : jobOpen,
      'applyLink': applyLink,
      'location': location,
      'experienceLevel':experienceLevel,
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
      jobOpen : json['jobOpen'],
      easyApply:json['easyApply'],
      jobId:json['jobId'],
      companyId: json['companyId'],
      companyName: json['companyName'],
      jobTitle: json['jobTitle'],
      experienceLevel:json['experienceLevel'],
      applyLink: json['applyLink'],
      location: json['location'],
      locationType: json['locationType'],
      postDate: json['postDate'],
      employmentType: json['employmentType'],
      applications: json['applications'],
      applicants: (json['applicants'] as List<dynamic>?)?.map((e) => e as String).toList(),
      about: json['about'],
      requirements: (json['requirements'] as List<dynamic>?)?.map((e) => e as String).toList(),
      salary: json['salary'] != null ? json['salary'].toDouble() : null,
    );
  }
}
