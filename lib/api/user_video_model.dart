// ignore_for_file: prefer_typing_uninitialized_variables

class UserVideos {
  final int id;
  final String name;
  final String? description;
  final String? videolink;
  var date;
  final String? status;

  UserVideos({
    required this.id,
    required this.name,
    required this.description,
    required this.videolink,
    required this.date,
    required this.status,
  });

  factory UserVideos.fromJson(Map<String, dynamic> json) {
    return UserVideos(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      videolink: json['video_link'],
      date: json['created_at'],
      status: json['status'],
    );
  }
}
