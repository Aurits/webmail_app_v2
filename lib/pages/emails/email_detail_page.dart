import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../models/mail.dart';

class EmailDetailPage extends StatelessWidget {
  final Mail email;

  const EmailDetailPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Details'),
        backgroundColor: Colors.green[400],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              email.subject,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'From: ${email.sender}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'To: ${email.receiver}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Reply-To: ${email.replyTo}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${email.date}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Html(data: email.message),
            const SizedBox(height: 16),
            if (email.attachments.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attachments:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(email.attachments),
                ],
              ),
            const SizedBox(height: 32),
            // Footer
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.grey[200],
              child: Text(
                'This email is brought to you by Your Email App',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
