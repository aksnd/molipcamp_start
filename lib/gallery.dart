import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import './contact.dart';

class gallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PhotoGridScreen(),
    );
  }
}

class PhotoGridScreen extends StatefulWidget {
  @override
  _PhotoGridScreenState createState() => _PhotoGridScreenState();
}

class _PhotoGridScreenState extends State<PhotoGridScreen> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    final jsonString = await rootBundle.loadString('assets/contacts.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    setState(() {
      contacts = jsonData.map((item) => Contact.fromJson(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Grid'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3x3 그리드
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // 사진 클릭 시 데이터 불러오기
                _showContactDetails(context, contacts[index]);
              },
              child: Image.network(
                contacts[index].image,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }

  void _showContactDetails(BuildContext context, Contact contact) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(contact.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(contact.image),
              SizedBox(height: 10),
              Text('Phone: ${contact.phone}'),
            ],
          ),
        );
      },
    );
  }
}