class Mechanic {
  final String id;
  final String name;
  final String image;
  final double rating;
  final String specialization;
  final int experience;
  final double price;
  final bool isAvailable;

  Mechanic({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.specialization,
    required this.experience,
    required this.price,
    this.isAvailable = true,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'rating': rating,
      'specialization': specialization,
      'experience': experience,
      'price': price,
      'isAvailable': isAvailable,
    };
  }

  // Create from Map
  factory Mechanic.fromMap(Map<String, dynamic> map) {
    return Mechanic(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      rating: map['rating'],
      specialization: map['specialization'],
      experience: map['experience'],
      price: map['price'],
      isAvailable: map['isAvailable'] ?? true,
    );
  }
}
