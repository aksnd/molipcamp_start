import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleContact {
  String name;
  String phone;
  String image;
  String birthday;

  SimpleContact({required this.name, required this.phone, required this.image, required this.birthday});

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'image': image,
    'birthday': birthday,
  };

  factory SimpleContact.fromJson(Map<String, dynamic> json) {
    return SimpleContact(
      name: json['name'],
      phone: json['phone'],
      image: json['image'],
      birthday: json['birthday'],
    );
  }

}

/*
Future<void> saveContacts(List<Contact> contacts) async { //Contacts를 local에 저장
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> jsonContacts = contacts.map((contact) => jsonEncode(contact.toJson())).toList();
  await prefs.setStringList('contacts', jsonContacts);
}

Future<List<Contact>> loadContacts() async { //Contacts를 local에서 load.
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String>? jsonContacts = prefs.getStringList('contacts');
  if (jsonContacts != null) {
    return jsonContacts.map((jsonContact) => Contact.fromJson(jsonDecode(jsonContact))).toList();
  } else {
    return [];
  }
}*/
