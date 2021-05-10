//reg user

class UserModel {
  String phoneNumber;
  String uid;
  String fullName;
  String birthDay;
  String photoUrl;
  String type;
  String longitude;
  String latitude;

  UserModel({
    this.fullName,
    this.uid,
    this.birthDay,
    this.type,
    this.phoneNumber,
    this.photoUrl,
    this.longitude,
    this.latitude,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      birthDay: json["birthDay"],
      fullName: json["fullName"],
      phoneNumber: json["phoneNumber"],
      photoUrl: json["photoUrl"],
      uid: json["uid"],
      type: json["type"],
      latitude: json["latitude"],
      longitude: json["longitude"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "birthDay": this.birthDay,
      "fullName": this.fullName,
      "phoneNumber": this.phoneNumber,
      "photoUrl": this.photoUrl,
      "uid": this.uid,
      "type": this.type,
      "longitude": this.longitude,
      "latitude": this.latitude,
    };
  }
}
