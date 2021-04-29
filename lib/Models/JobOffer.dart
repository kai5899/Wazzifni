class JobOffer {
  int id;
  String jobTitle;
  String jobType; //full time , part time ,intern ,freelance
  String jobDescription;
  String posterId;
  List<dynamic> requirements;
  String salary;
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
      "posterId": this.posterId,
      "location": this.location,
    };
  }
}
