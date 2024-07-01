import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleContact {
  int index;
  String name;
  String phone;
  String image;
  String birthday;


  SimpleContact({required this.index, required this.name, required this.phone, required this.image, required this.birthday});

  Map<String, dynamic> toJson() => {
    'index': index,
    'name': name,
    'phone': phone,
    'image': image,
    'birthday': birthday,
  };

  factory SimpleContact.fromJson(Map<String, dynamic> json) {
    return SimpleContact(
      index: json['index'],
      name: json['name'],
      phone: json['phone'],
      image: json['image'],
      birthday: json['birthday'],
    );
  }

}

