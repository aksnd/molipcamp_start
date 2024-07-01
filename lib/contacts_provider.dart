// contacts_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './contact.dart'; // Adjust as per your project structure

class ContactsProvider extends ChangeNotifier {
  List<SimpleContact> _contacts = [];
  List<SimpleContact> _filteredcontacts = [];
  String _SearchQuery = '';
  List<SimpleContact> get contacts => _contacts; //외부에서 contacts로 접근할때 _contacts와 같게 취급
  List<SimpleContact> get filteredcontacts => _filteredcontacts; //외부에서 filteredcontacts로 접근할때 _filteredcontacts와 같게 취급
  ContactsProvider() {
    //첫 Contacts가 생성될때 실행되는 함수, load만으로 가져옴
    _loadContacts();
  }

  Future<void> _loadContacts() async { //기본적으로 load하고, 만약 비어있으면 json에서 가져오는 함수
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? jsonContacts = prefs.getStringList('contacts');
      //sharedPreferences에서 app 내 data 가져오기
      if (jsonContacts != null) { //app 내 data로 _contacts 만들기
        _contacts = jsonContacts.map((jsonContact) => SimpleContact.fromJson(jsonDecode(jsonContact))).toList();
      } else { //app내 data가 없을때 json으로 _contacts 만들기
        // If no contacts in SharedPreferences, load from asset file
        final jsonString = await rootBundle.loadString('assets/contacts.json');
        final List<dynamic> jsonData = jsonDecode(jsonString);
        _contacts = jsonData.map((item) => SimpleContact.fromJson(item)).toList();
      }
      //contacts의 전반적인 상태관리 함수 4개라 생각하면 편함
      _sortContacts(); //_contacts ㄱㄴㄷ순 정렬, index 재할당
      _saveContacts(); //_contacts 그대로 sharedPreference에 저장
      _filterContacts(); //검색중이었을떄, 검색중인놈만 뜨게하기위해 filteredcontacts 재검색
      notifyListeners(); // Notify listeners when contacts are loaded
    } catch (e) {
      print('Error loading contacts: $e');
      // Handle error as needed (e.g., show error message)
    }
  }

  void _filterContacts() { // 상태관리 함수 3호 검색어랑 매칭해서 확인하기
    if (_SearchQuery.isEmpty) {
      _filteredcontacts = _contacts;
    } else {
      _filteredcontacts = _contacts
          .where((contact) => contact.name.toLowerCase().contains(_SearchQuery.toLowerCase()))
          .toList();
    }
  }



  Future<void> _saveContacts() async { //sharedpreferences로 저장 (수정할때 마다 선언 필요)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonContacts = _contacts.map((contact) => jsonEncode(contact.toJson())).toList();
    await prefs.setStringList('contacts', jsonContacts);
  }

  void _sortContacts(){ // ㄱㄴㄷ순 정렬, _updateIndexes는 인덱스 실제 배열하고 같게 해서 _contacts에 저장
    _contacts.sort((a,b)=> a.name.compareTo(b.name));
    _updateIndexes();
  }

  void _updateIndexes() {
    for (int i = 0; i < _contacts.length; i++) {
      _contacts[i].index = i;
    }
  }


  void addContact(SimpleContact contact) { //추가하기
    _contacts.add(contact);
    _sortContacts();
    _saveContacts();
    _filterContacts();
    notifyListeners(); // Notify listeners after adding a new contact
  }

  void updateContact(int index, SimpleContact updatedContact) { //수정하기
    if (index >= 0 && index < _contacts.length) {
      _contacts[index] = updatedContact;
      _sortContacts();
      _saveContacts();
      _filterContacts();
      notifyListeners(); // Notify listeners after updating a contact
    }
  }
  void deleteContact(int index) { //삭제하기
    if (index >= 0 && index < _contacts.length) {
      _contacts.removeAt(index);
      _sortContacts();
      _saveContacts(); // Save contacts to SharedPreferences after deleting
      _filterContacts();
      notifyListeners(); // Notify listeners after deleting a contact
    }
  }

  void updateSearchQuery(String query) { // 검색할때 Query가 변경되었을때 사용되는 함수
    _SearchQuery = query;
    _filterContacts();
    notifyListeners();
  }

}