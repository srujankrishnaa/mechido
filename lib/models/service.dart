class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final int duration; // in minutes
  final bool isPopular;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.duration,
    this.isPopular = false,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'duration': duration,
      'isPopular': isPopular,
    };
  }

  // Create from Map
  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      image: map['image'],
      duration: map['duration'],
      isPopular: map['isPopular'] ?? false,
    );
  }
}
