class Contact {
  final String name;
  final String phone;
  final String image;

  Contact({required this.name, required this.phone, required this.image});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      phone: json['phone'],
      image: json['image'],
    );
  }
}
