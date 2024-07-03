import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import './contact.dart';
import './dialog.dart';
import 'package:provider/provider.dart';
import 'contacts_provider.dart';
import 'groups_provider.dart';
import 'dart:io';
class gallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
    return Consumer2<ContactsProvider,GroupsProvider>(
      builder: (context,contactsProvider, groupsProvider, child){
        final groups = groupsProvider.groups;
        final contacts = (contactsProvider.widget2GroupFilteredContacts.where((c)=>
        (c.image!='assets/images/default.png')).toList()
        );
        List<String> dropDownGroup = contactsProvider.nowGroup;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Photo Grid'),
            actions: <Widget>[
              Container(
                  width: 130,
                  alignment: Alignment.centerRight,
                  child:GroupDropdown(
                      groups: groups,
                      selectedGroup: dropDownGroup[1],
                      onGroupChanged:(String newGroup){
                        dropDownGroup[1]= newGroup;
                        Provider.of<ContactsProvider>(context, listen: false).updateNowGroup(dropDownGroup, 1);
                      },
                      widgetFrom: 1,
                  )),
              const SizedBox(width: 10,),
            ],
          ),
          body:Padding(
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
                    _showContactDetails(context, contacts[index], groups);
                  },
                  /*child: Image.asset(
              contacts[index].image,
              fit: BoxFit.cover,
            ),*/
                  child: _getImageProvider(contacts[index].image),
                );
              },
            ),
          ),
        );
      }
    );
  }
  
  Image _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('asset') || imageUrl.startsWith('assets')) {
      return Image.asset(imageUrl, fit:BoxFit.cover);
    } else {
      return Image.file(File(imageUrl),fit:BoxFit.cover);
    }
  }
  
  void _showContactDetails(BuildContext context, SimpleContact contact, Set<String> groups) {
    showProfile(context, contact, groups, false, Null);
  }
}