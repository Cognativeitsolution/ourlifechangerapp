class ProfileData {
  String name;
  String email;
  String username;
  String contact;
  String package;
  String image;

  ProfileData(
      {required this.name,
      required this.email,
      required this.username,
      required this.contact,
      required this.package,
      required this.image});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      name: json['name'],
      email: json['email'],
      username: json['user_name'],
      contact: json['contact'],
      package: json['package_name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "user_name": username,
        "contact": contact,
        "package_name": package,
        "image": image,
      };
}
