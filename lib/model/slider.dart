class Silder {
  String image;

  Silder({
    required this.image,
  });

  factory Silder.fromJson(Map<String, dynamic> json) {
    return Silder(
      image: json['image'],
    );
  }
}
