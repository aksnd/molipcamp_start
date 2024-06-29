// contacts_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './contact.dart'; // Adjust as per your project structure

class ContactsProvider extends ChangeNotifier {
  List<SimpleContact> _contacts = [];

  List<SimpleContact> get contacts => _contacts;

  ContactsProvider() {
    // Load contacts initially when the provider is instantiated
    _loadContacts();

  }

  Future<void> _loadContacts() async { //기본적으로 load하고, 만약 비어있으면 json에서 가져오는 함수
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? jsonContacts = prefs.getStringList('contacts');

      if (jsonContacts != null) {
        _contacts = jsonContacts.map((jsonContact) => SimpleContact.fromJson(jsonDecode(jsonContact))).toList();
      } else {
        // If no contacts in SharedPreferences, load from asset file
        final jsonString = await rootBundle.loadString('assets/contacts.json');
        final List<dynamic> jsonData = jsonDecode(jsonString);
        _contacts = jsonData.map((item) => SimpleContact.fromJson(item)).toList();
      }
      _saveContacts();
      notifyListeners(); // Notify listeners when contacts are loaded
    } catch (e) {
      print('Error loading contacts: $e');
      // Handle error as needed (e.g., show error message)
    }
  }
  Future<void> _saveContacts() async { //sharedpreferences로 저장 (수정할때 마다 선언 필요)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonContacts = _contacts.map((contact) => jsonEncode(contact.toJson())).toList();
    await prefs.setStringList('contacts', jsonContacts);
  }


  void addContact(SimpleContact contact) { //추가하기
    _contacts.add(contact);
    _saveContacts();
    notifyListeners(); // Notify listeners after adding a new contact
  }

  void updateContact(int index, SimpleContact updatedContact) { //수정하기
    if (index >= 0 && index < _contacts.length) {
      _contacts[index] = updatedContact;
      _saveContacts();
      notifyListeners(); // Notify listeners after updating a contact
    }
  }
  void deleteContact(int index) { //삭제하기
    if (index >= 0 && index < _contacts.length) {
      _contacts.removeAt(index);
      _saveContacts(); // Save contacts to SharedPreferences after deleting
      notifyListeners(); // Notify listeners after deleting a contact
    }
  }
}