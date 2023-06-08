class Noti {
  final String? title;
  final String? description;
  final String? dTime;

  Noti({
    required this.title,
    required this.description,
    required this.dTime,
  });

  factory Noti.fromJson(Map<String, dynamic> json) {
    return Noti(
      title: json['title'],
      description: json['description'],
      dTime: json['created_at'],
    );
  }
}
