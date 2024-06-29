// contacts_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './contact.dart'; // Adjust as per your project structure

class ContactsProvider extends ChangeNotifier {
  List<Contact> _contacts = [];

  List<Contact> get contacts => _contacts;

  ContactsProvider() {
    // Load contacts initially when the provider is instantiated
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? jsonContacts = prefs.getStringList('contacts');

      if (jsonContacts != null) {
        _contacts = jsonContacts.map((jsonContact) => Contact.fromJson(jsonDecode(jsonContact))).toList();
      } else {
        // If no contacts in SharedPreferences, load from asset file
        final jsonString = await rootBundle.loadString('assets/contacts.json');
        final List<dynamic> jsonData = jsonDecode(jsonString);
        _contacts = jsonData.map((item) => Contact.fromJson(item)).toList();
      }
      _saveContacts();
      notifyListeners(); // Notify listeners when contacts are loaded
    } catch (e) {
      print('Error loading contacts: $e');
      // Handle error as needed (e.g., show error message)
    }
  }
  Future<void> _saveContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonContacts = _contacts.map((contact) => jsonEncode(contact.toJson())).toList();
    await prefs.setStringList('contacts', jsonContacts);
  }


  void addContact(Contact contact) {
    _contacts.add(contact);
    _saveContacts();
    notifyListeners(); // Notify listeners after adding a new contact
  }

  void updateContact(int index, Contact updatedContact) {
    if (index >= 0 && index < _contacts.length) {
      _contacts[index] = updatedContact;
      _saveContacts();
      notifyListeners(); // Notify listeners after updating a contact
    }
  }
}