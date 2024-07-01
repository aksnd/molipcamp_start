import 'package:flutter/material.dart';
import './contact.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'contacts_provider.dart';
import 'groups_provider.dart';
import 'package:provider/provider.dart';

Future<void> showProfile(BuildContext context, SimpleContact contact, Set<String> groups, bool condition , onUpdate) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button to dismiss
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.all(10),
        title: Text('프로필 확인'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // _getImageProvider(contact.image),
              SizedBox(height: 20,),
              Container(
                width: 200, // 원하는 크기로 설정하세요
                height: 200, // 원하는 크기로 설정하세요
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: _getImageProvider(contact.image),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "이름 ${contact.name}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "전화번호 ${contact.phone}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "생일 ${contact.birthday}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "MBTI ${contact.mbti}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "그룹 ${contact.group}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          if(condition)
            TextButton(
              child: Text('delete'),
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<ContactsProvider>(context, listen: false).deleteContact(contact.index);
              },
            ),
          if (condition)
            TextButton(
              child: Text('edit'),
              onPressed: () {
                Navigator.of(context).pop();
                editProfile(context, contact,groups,onUpdate);
              },
            ),
          TextButton(
            child: Text('close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



Future<void> editProfile(BuildContext context, SimpleContact contact,Set<String> groups, onUpdate) async {
  SimpleContact editedContact = SimpleContact(index:contact.index, name: contact.name, phone: contact.phone, image: contact.image, birthday: contact.birthday,group: contact.group, mbti: contact.mbti);
  final TextEditingController _controller1 = TextEditingController(text: editedContact.name);
  final TextEditingController _controller2 = TextEditingController(text: editedContact.phone);
  final TextEditingController _controller3 = TextEditingController(text: editedContact.birthday);
  final TextEditingController _controller4 = TextEditingController(text: editedContact.mbti);


  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button to dismiss
    builder: (context){
      return StatefulBuilder(
        builder: (context, setState){
          Future getImage(ImageSource imageSource) async {
            //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
            final ImagePicker picker = ImagePicker();
            final XFile? pickedFile = await picker.pickImage(source: imageSource);
            if (pickedFile != null) {
              setState((){
                editedContact.image = pickedFile.path;
              });
            }
          }
          return AlertDialog(
            //title: Text('Input Dialog'),
            contentPadding: EdgeInsets.all(10),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  // _getImageProvider(contact.image),
                  SizedBox(height: 20,),
                  Container(
                    width: 200, // 원하는 크기로 설정하세요
                    height: 200, // 원하는 크기로 설정하세요
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: _getImageProvider(editedContact.image),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            Text(
                              "이름 ",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(width: 8), // 간격 조정을 위한 SizedBox
                            Expanded(
                              child: TextField(
                                controller: _controller1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            Text(
                              "전화번호 ",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(width: 8), // 간격 조정을 위한 SizedBox
                            Expanded(
                              child: TextField(
                                controller: _controller2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            Text(
                              "생일 ",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(width: 8), // 간격 조정을 위한 SizedBox
                            Expanded(
                              child: TextField(
                                controller: _controller3,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            Text(
                              "MBTI ",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(width: 8), // 간격 조정을 위한 SizedBox
                            Expanded(
                              child: TextField(
                                controller: _controller4,
                              ),
                            ),
                          ],
                         ),
                        SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            Text(
                              "그룹 ",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(width: 8), // 간격 조정을 위한 SizedBox
                            Expanded(child: GroupDropdown(
                                groups: groups,
                                selectedGroup: editedContact.group,
                                onGroupChanged:(String newGroup){
                                  editedContact.group= newGroup;
                                }
                            )),
                          ],
                        ),
                      ],
                  ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('image'),
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
              ),
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Save'),
                onPressed: () {
                  editedContact.name = _controller1.text;
                  editedContact.phone = _controller2.text;
                  editedContact.birthday = _controller3.text;
                  onUpdate(contact.index, editedContact);
                  editedContact.mbti = _controller4.text;
                  print(_controller1.text);
                  print(_controller2.text);
                  print(_controller3.text);
                  print(_controller4.text);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },

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
class GroupDropdown extends StatefulWidget {
  final Set<String> groups;
  final String selectedGroup;
  final Function(String) onGroupChanged;

  const GroupDropdown({
    Key? key,
    required this.groups,
    required this.selectedGroup,
    required this.onGroupChanged,
  }) : super(key: key);

  @override
  _GroupDropdownState createState() => _GroupDropdownState();
}

class _GroupDropdownState extends State<GroupDropdown>{
  String? _selectedGroup;

  @override
  void initState(){
    super.initState();
    _selectedGroup = widget.selectedGroup;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedGroup,
      hint: Text(_selectedGroup ?? 'Select Group'),
      items: widget.groups.map((String group) {
        return DropdownMenuItem<String>(
          value: group,
          child: Text(group),
        );
      }).toList()
        ..add(
          const DropdownMenuItem<String>(
            value: 'new_group',
            child: Text('새 그룹 추가'),
          ),
        ),
      onChanged: (String? newValue) {
        if (newValue == 'new_group') {
          //수정하기
        } else if (newValue != null&& newValue !=_selectedGroup) {
          setState((){
            _selectedGroup=newValue;
          });
          widget.onGroupChanged(newValue);
        }
      },
    );
  }
}

