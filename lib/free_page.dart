import 'package:flutter/material.dart';
import 'contact.dart';

class QuizPage extends StatelessWidget {
  final List<Contact> contacts;

  const QuizPage({Key? key, required this.contacts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Page'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                contact.image != null
                    ? Image.network(contact.image!)
                    : const Icon(Icons.help_outline, size: 100),
                const SizedBox(height: 16),
                const Text('Who is this person?'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Implement quiz logic here
                  },
                  child: Text('A. ${contact.name}'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Implement quiz logic here
                  },
                  child: Text('B. 김스틴'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Implement quiz logic here
                  },
                  child: Text('C. 이주노'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
