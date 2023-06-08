class AllPackage {
  final String? name;
  final String? image;
  final String? description;
  final String? limit;
  final String? price;
  final int duration;
  final int id;

  AllPackage({
    required this.name,
    required this.image,
    required this.description,
    required this.limit,
    required this.price,
    required this.duration,
    required this.id,
  });

  factory AllPackage.fromJson(Map<String, dynamic> json) {
    return AllPackage(
      name: json['name'],
      image: json['image'],
      description: json['description'],
      limit: json['limit'],
      price: json['price'],
      duration: int.parse(json['duration'].toString()),
      id: int.parse(json['id'].toString()),
      //duration: json['duration']
    );
  }
}
