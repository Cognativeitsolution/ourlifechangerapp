class ProfileData {
  String name;
  String email;
  String username;
  String contact;
  String package;
  String image;
  String? secemail;

  ProfileData(
      {required this.name,
      required this.email,
      required this.username,
      required this.contact,
      required this.package,
      required this.image,
      this.secemail});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
        name: json['name'],
        email: json['email'],
        username: json['user_name'],
        contact: json['contact'],
        package: json['package_name'],
        image: json['image'],
        secemail: json['secondary_email']);
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "user_name": username,
        "contact": contact,
        "package_name": package,
        "image": image,
        "secondary_email": secemail
      };
}
