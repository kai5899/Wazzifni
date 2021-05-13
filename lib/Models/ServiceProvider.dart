class ServiceProvider {
  String phoneNumber;
  String uid;
  String fullName;
  String birthDay;
  String photoUrl;
  String type;
  String longitude;
  String latitude;
  String bio;
  bool available;
  String position;

  String profession;
  String priceRange;

  ServiceProvider({
    this.fullName,
    this.uid,
    this.birthDay,
    this.phoneNumber,
    this.photoUrl,
    this.type,
    this.priceRange,
    this.profession,
    this.longitude,
    this.latitude,
    this.bio,
    this.available,
    this.position,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      birthDay: json["birthDay"],
      fullName: json["fullName"],
      phoneNumber: json["phoneNumber"],
      photoUrl: json["photoUrl"],
      uid: json["uid"],
      type: json["type"],
      priceRange: json["priceRange"],
      profession: json["profession"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      bio: json["bio"],
      available: json["available"],
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
      "priceRange": this.priceRange,
      "profession": this.profession,
      "longitude": this.longitude,
      "latitude": this.latitude,
      "bio": this.bio,
      "available": this.available,
    };
  }
}
