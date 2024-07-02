// contacts_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './contact.dart'; // Adjust as per your project structure

class GroupsProvider extends ChangeNotifier {
  Set<String> _groups = {};

  Set<String> get groups=> _groups;

  GroupsProvider() {
    // Load contacts initially when the provider is instantiated
    _loadGroups();

  }
  Future<void> _loadGroups() async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Set<String>? jsonGroups = prefs.getStringList('groups')?.toSet()?? {};

      if (jsonGroups.isNotEmpty){
        _groups = jsonGroups.toSet();
      } else{
        final jsonString = await rootBundle.loadString('assets/contacts.json');
        final List<dynamic> jsonData = jsonDecode(jsonString);
        List<SimpleContact> contacts = jsonData.map((item) => SimpleContact.fromJson(item)).toList();
        List<String> groups = contacts.map((item)=> item.group).toList();
        groups.add('기타');
        _groups= groups.toSet();
      }
      _saveGroups();
      notifyListeners();
    } catch(e){
      print('Error loading groups: $e');
    }
  }

  Future<void> _saveGroups() async {
    SharedPreferences  prefs= await SharedPreferences.getInstance();
    await prefs.setStringList('groups',_groups.toList());
  }

  void addGroups(String group) { //추가하기
    _groups.add(group);
    _saveGroups();
    notifyListeners(); // Notify listeners after adding a new contact
  }

  void deleteGroup(String group) { //삭제하기
    if (_groups.contains(group)) {
      _groups.remove(group);
      _saveGroups();
      notifyListeners(); // Notify listeners after deleting a contact
    }
  }
}