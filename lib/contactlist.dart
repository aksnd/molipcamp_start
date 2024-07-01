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

// 이 아래는 전화번호부 관련 import
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart' as NativeContact;
import 'package:contacts_service/contacts_service.dart' as ContactService;
import 'package:permission_handler/permission_handler.dart';

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
  final NativeContact.FlutterContactPicker _contactPicker = NativeContact.FlutterContactPicker();

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (!permission.isGranted) {
      await Permission.contacts.request();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ContactsProvider>(
      builder: (context,contactsProvider, child){
        final contacts = contactsProvider.contacts;
        return Scaffold(
          appBar: AppBar(
            title: const Text('전화번호부'),
          ),
          body: ListView.builder(
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
                    trailing: SizedBox(
                      width: 100,
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.call),
                            onPressed: () => _makePhoneCall(contact.phone),
                          ),
                          IconButton(
                            icon: const Icon(Icons.save),
                            onPressed: () async {
                              ContactService.Contact newContact = ContactService.Contact(
                                givenName: contact.name,
                                phones: [ContactService.Item(label: "mobile", value: contact.phone.replaceAll(RegExp(r'[^0-9]'),''))],
                              );
                              try{
                                await ContactService.ContactsService.addContact(newContact);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('연락처에 저장되었습니다'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }catch(e){
                                print('Failed to save contact to device: $e');
                              }
                            },
                          )
                        ],
                      )
                    )

                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),

          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  SimpleContact defaultContact = SimpleContact(name: 'no name', phone: '010-0000-0000', image: 'assets/images/default.png', birthday: '2000.01.01', mbti: 'ENTJ');
                  addContact(defaultContact);
                  editProfile(context, contacts[contacts.length-1],contacts.length-1,updateContact);
                },
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 16), // Adjust the spacing between FABs if necessary
              FloatingActionButton(
                onPressed: () async {
                  NativeContact.Contact? contact = await _contactPicker.selectContact();
                  if(contact!=null && contact.fullName!=null && contact.phoneNumbers!=null){
                    SimpleContact defaultContact = SimpleContact(name: contact.fullName!, phone: contact.phoneNumbers![0], image: 'assets/images/default.png', birthday: '2000.01.01', mbti: 'ENTJ');
                    addContact(defaultContact);
                  }

                },
                tooltip: 'Second FAB',
                child: Icon(Icons.contacts),
              ),
            ],
          ),
        );
      }
    );
  }
  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('asset') || imageUrl.startsWith('assets')) {
      return AssetImage(imageUrl);
    } else {
      return FileImage(File(imageUrl));
    }
  }
  void updateContact(int index, SimpleContact editedContact) {
    Provider.of<ContactsProvider>(context, listen: false).updateContact(index, editedContact);
  }

  void addContact(SimpleContact addContact){
    Provider.of<ContactsProvider>(context, listen: false).addContact(addContact);
  }


  void _makePhoneCall(String phoneNumber) async {
    final String cleanedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'),'');
    final Uri phoneUri = Uri(scheme: 'tel', host: cleanedPhoneNumber);
    await launchUrl(phoneUri);
  }
}
