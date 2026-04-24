class Nail {
  final String id;
  final String name;
  final String image;
  final String description;
  final int price;
  bool isFavorite;

  Nail({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    this.isFavorite = false,
  });

factory Nail.fromJson(Map<String, dynamic> json) {
  return Nail(
    id: json['id'].toString(),
    name: json['name'] ?? '',
    image: json['image'] ?? '',
    description: json['description'] ?? '',
    price: json['price'] ?? 0, // 🔥 WAJIB
    isFavorite: json['isFavorite'] ?? false,
  );
}
}