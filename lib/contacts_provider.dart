// contacts_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import './contact.dart'; // Adjust as per your project structure

class ContactsProvider extends ChangeNotifier {
  List<Contact> _contacts = [];

  List<Contact> get contacts => _contacts;

  ContactsProvider() {
    // Load contacts initially when the provider is instantiated
    loadContacts();
  }

  Future<void> loadContacts() async {
    try {
      final jsonString = await rootBundle.loadString('assets/contacts.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      _contacts = jsonData.map((item) => Contact.fromJson(item)).toList();
      notifyListeners(); // Notify listeners when contacts are loaded
    } catch (e) {
      print('Error loading contacts: $e');
      // Handle error as needed (e.g., show error message)
    }
  }

  void addContact(Contact contact) {
    _contacts.add(contact);
    notifyListeners(); // Notify listeners after adding a new contact
  }

  void updateContact(int index, Contact updatedContact) {
    if (index >= 0 && index < _contacts.length) {
      _contacts[index] = updatedContact;
      notifyListeners(); // Notify listeners after updating a contact
    }
  }
}