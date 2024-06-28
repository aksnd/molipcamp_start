class Contact {
  final String name;
  final String phone;
  final String image;
  final String birthday;

  Contact({required this.name, required this.phone, required this.image, required this.birthday});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      phone: json['phone'],
      image: json['image'],
      birthday: json['birthday'],
    );
  }
}
