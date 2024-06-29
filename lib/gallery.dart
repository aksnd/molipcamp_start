import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import './contact.dart';
import './dialog.dart';
import 'package:provider/provider.dart';
import 'contacts_provider.dart';
import 'dart:io';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Grid'),
      ),
      body: Consumer<ContactsProvider>(
        builder: (context,contactsProvider, child){
          final contacts = contactsProvider.contacts;
          return Padding(
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
                  /*child: Image.asset(
                    contacts[index].image,
                    fit: BoxFit.cover,
                  ),*/
                  child: _getImageProvider(contacts[index].image),
                );
              },
            ),
          );
        }
      ),
    );
  }
  
  Image _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('asset') || imageUrl.startsWith('assets')) {
      return Image.asset(imageUrl, fit:BoxFit.cover);
    } else {
      return Image.file(File(imageUrl),fit:BoxFit.cover);
    }
  }
  
  void _showContactDetails(BuildContext context, SimpleContact contact) {
    showProfile(context, contact, 0, false, Null);
  }
}