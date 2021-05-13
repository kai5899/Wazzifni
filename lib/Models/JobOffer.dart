import 'package:equatable/equatable.dart';

class JobOffer extends Equatable {
  int id;
  String jobTitle;
  String jobType; //full time , part time ,intern ,freelance
  String jobDescription;
  String posterId;
  List<dynamic> requirements;
  double salary;
  String currency;
  double latitude;
  double longitude;
  String location;

  JobOffer({
    this.id,
    this.jobDescription,
    this.requirements,
    this.jobTitle,
    this.jobType,
    this.salary,
    this.latitude,
    this.currency,
    this.longitude,
    this.posterId,
    this.location,
  });

  factory JobOffer.fromMap(Map<String, dynamic> json) {
    return JobOffer(
      id: json["id"],
      jobTitle: json["jobTitle"],
      jobType: json["jobType"],
      jobDescription: json["jobDescription"],
      requirements: json["jobRequirements"],
      longitude: json["longitude"],
      latitude: json["latitude"],
      salary: json["salary"],
      currency: json["currency"],
      posterId: json["posterId"],
      location: json["location"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "jobTitle": this.jobTitle,
      "longitude": this.longitude,
      "latitude": this.latitude,
      "jobDescription": this.jobDescription,
      "jobRequirements": this.requirements,
      "jobType": this.jobType,
      "salary": this.salary,
      "currency": this.currency,
      "posterId": this.posterId,
      "location": this.location,
    };
  }

  @override
  List<Object> get props => [
        id,
        jobDescription,
        jobTitle,
        jobType,
        location,
        currency,
        salary,
        latitude,
        longitude,
        posterId,
        requirements
      ];
}
