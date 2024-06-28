import 'package:flutter/material.dart';
import './contact.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<void> showProfile(BuildContext context, Contact contact, int index, onUpdate) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button to dismiss
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('프로필 확인'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This is a popup dialog.'),
              Text(contact.name),
              Text(contact.phone),
              Text(contact.image),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('edit'),
            onPressed: () {
              Navigator.of(context).pop();
              editProfile(context, contact,index,onUpdate);
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



Future<void> editProfile(BuildContext context, Contact contact,int index, onUpdate) async {
  Contact editedContact = Contact(name: contact.name, phone: contact.phone, image: contact.image, birthday: contact.birthday);
  final TextEditingController _controller1 = TextEditingController(text: editedContact.name);
  final TextEditingController _controller2 = TextEditingController(text: editedContact.phone);

  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      editedContact.image = pickedFile.path;
    }
  }



  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button to dismiss
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Input Dialog'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _controller1,
              ),
              TextField(
                controller: _controller2,
              ),
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
              onUpdate(index, editedContact);
              print(_controller1.text);
              print(_controller2.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );


}


