// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../../models/mail.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class EmailDetailPage extends StatelessWidget {
  final Mail email;

  const EmailDetailPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Details', style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                  ),
        backgroundColor: Colors.green[400],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              email.subject,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'From: ${email.replyTo}',
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
            const Divider(),
            const SizedBox(height: 16),
            HtmlWidget(
              // the first parameter (`html`) is required
              email.message,

              // all other parameters are optional, a few notable params:

              // specify custom styling for an element
              // see supported inline styling below
              customStylesBuilder: (element) {
                if (element.classes.contains('foo')) {
                  return {'color': 'red'};
                }

                return null;
              },

              customWidgetBuilder: (element) {
                if (element.attributes['foo'] == 'bar') {
                  // render a custom block widget that takes the full width
                  return Container();
                }

                if (element.attributes['fizz'] == 'buzz') {
                  // render a custom widget inline with surrounding text
                  return InlineCustomWidget(
                    child: Container(),
                  );
                }

                return null;
              },

              // this callback will be triggered when user taps a link
              onTapUrl: (url) {
                print('tapped url');
                return true;
              },

              // select the render mode for HTML body
              // by default, a simple `Column` is rendered
              // consider using `ListView` or `SliverList` for better performance
              renderMode: RenderMode.column,

              // set the default styling for text
              textStyle: const TextStyle(fontSize: 14),
            ),
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
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.grey[200],
              child: Text(
                'This email is brought to you by Makerere Webmail',
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
