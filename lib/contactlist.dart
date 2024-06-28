import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'contact.dart'; // Contact 클래스를 import
import './dialog.dart';
import 'package:image_picker/image_picker.dart';

class phone_number extends StatelessWidget {
  const phone_number({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final String response = await rootBundle.loadString('assets/contacts.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      _contacts = data.map((contact) => Contact.fromJson(contact)).toList();
    });
  }
  void updateContact(int index, Contact editedContact) {
    setState(() {
      _contacts[index] = editedContact;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('전화번호부'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _contacts.length,
          itemBuilder: (context, index) {
            final contact = _contacts[index];
            return Column(
              children: [
                ListTile(
                  title: Text(contact.name),
                  subtitle: Text(contact.phone),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: _getImageProvider(contact.image),
                  ),
                  onTap: (){
                    showProfile(context, contact, index, updateContact);
                  },
                  trailing: const Icon(Icons.call),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>print("button clicked"),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return NetworkImage(imageUrl);
    } else {
      return FileImage(File(imageUrl));
    }
  }
}
