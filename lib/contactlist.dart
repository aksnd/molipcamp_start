import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:kaist_week1/contacts_provider.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'contact.dart'; // Contact 클래스를 import
import './dialog.dart';
import 'package:provider/provider.dart';
import 'contacts_provider.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('전화번호부'),
      ),
      body: Consumer<ContactsProvider>(
        builder: (context,contactsProvider, child){
          final contacts = contactsProvider.contacts;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
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
                      showProfile(context, contact, index, true, updateContact);
                    },
                    trailing:IconButton(
                      icon: const Icon(Icons.call),
                      onPressed: () => _makePhoneCall(contact.phone),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>print("button clicked"),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('asset') || imageUrl.startsWith('assets')) {
      return AssetImage(imageUrl);
    } else {
      return FileImage(File(imageUrl));
    }
  }
  void updateContact(int index, Contact editedContact) {
    Provider.of<ContactsProvider>(context, listen: false).updateContact(index, editedContact);
  }

  void addContact(Contact addContact){
    Provider.of<ContactsProvider>(context, listen: false).addContact(addContact);
  }

  void _makePhoneCall(String phoneNumber) async {
    final String cleanedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'),'');
    final Uri phoneUri = Uri(scheme: 'tel', host: cleanedPhoneNumber);
    await launchUrl(phoneUri);
  }
}
