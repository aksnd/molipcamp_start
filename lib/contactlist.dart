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
import 'groups_provider.dart';
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
    return Consumer2<ContactsProvider,GroupsProvider>(
      builder: (context,contactsProvider, groupsProvider, child){
        final contacts = contactsProvider.contacts;
        final groups = groupsProvider.groups;
        List<String> dropDownGroup = contactsProvider.nowGroup;
        final filteredcontacts = contactsProvider.filteredcontacts;
        final groupfilteredcontacts = contactsProvider.widget1GroupFilteredContacts;
        return Scaffold(
          appBar: AppBar(
            title: const Text('전화번호부'),
            actions: <Widget>[
              Container(
                width: 130,
                alignment: Alignment.centerRight,
                child:Flexible(
                  child: GroupDropdown(
                    groups: groups,
                    selectedGroup: contactsProvider.nowGroup[0],
                    onGroupChanged:(String newGroup){
                      dropDownGroup[0]= newGroup;
                      Provider.of<ContactsProvider>(context, listen: false).updateNowGroup(dropDownGroup, 0);
                    }, widgetFrom: 0,
                  )
                )),
              const SizedBox(width: 10,),
              IconButton( // 단순추가
                icon: Icon(Icons.add),
                onPressed: () {
                  SimpleContact defaultContact = SimpleContact(index: 1,name: '', phone: '010-0000-0000', image: 'assets/images/default.png', birthday: '2000.01.01', group: '기타', mbti: 'ENTJ');
                  editProfile(context, defaultContact, groups, addContact);
                },
              ),
              IconButton( //전화번호부 기반 추가
                icon: Icon(Icons.contact_phone),
                onPressed: () async {
                  NativeContact.Contact? contact = await _contactPicker.selectContact();
                  if(contact!=null && contact.fullName!=null && contact.phoneNumbers!=null){
                    SimpleContact defaultContact = SimpleContact(index: 1,name: contact.fullName!, phone: formatPhoneNumber(contact.phoneNumbers![0]),group:'기타', image: 'assets/images/default.png', birthday: '2000.01.01',mbti: 'ENTJ');
                    addContact(1, defaultContact);

                  }
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField( // 검색 기능을 위한 입력칸
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (query) { //변경될때마다 query기반 연락처 검색(이름 기준)
                    Provider.of<ContactsProvider>(context, listen: false).updateSearchQuery(query);
                  },
                ),
              ),
              Expanded(
                child:ListView.builder(
                  itemCount: groupfilteredcontacts.length,
                  itemBuilder: (context, index) { // 이 index는 filteredcontacts의 index 이므로 Read말고는 부적합
                    final contact = groupfilteredcontacts[index];
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
                              showProfile(context, contact, groups, true, updateContact);
                            },
                            trailing: SizedBox(
                                width: 100,
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.call_rounded),
                                      onPressed: () => _makePhoneCall(contact.phone),
                                    ),
                                    IconButton(
                                      // icon: const Icon(Icons.save),
                                      icon: const Icon(Icons.download),
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
              ),

            ],
          ),
        );
      }
    );
  }
  ImageProvider _getImageProvider(String imageUrl) { //사진 방식에 따라 다르게 load하는 함수
    if (imageUrl.startsWith('asset') || imageUrl.startsWith('assets')) {
      return AssetImage(imageUrl);
    } else {
      return FileImage(File(imageUrl));
    }
  }
  void updateContact(int index, SimpleContact editedContact) { //수정
    Provider.of<ContactsProvider>(context, listen: false).updateContact(index, editedContact);
  }

  void addContact(int _, SimpleContact addContact){ //index는 필요없지만, updateContact와 똑같이 입력받을려고 저래해놓음.
    Provider.of<ContactsProvider>(context, listen: false).addContact(addContact);
  }
  String formatPhoneNumber(String phoneNumber) { //전화번호 양식
    if (phoneNumber.length == 10) {
      return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6)}';
    } else if (phoneNumber.length == 11) {
      return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 7)}-${phoneNumber.substring(7)}';
    }
    // Handle other cases if necessary
    return phoneNumber; // Return original if not a recognized format
  }

  void _makePhoneCall(String phoneNumber) async {
    final String cleanedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'),'');
    final Uri phoneUri = Uri(scheme: 'tel', host: cleanedPhoneNumber);
    await launchUrl(phoneUri);
  }
}
