import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';
import 'package:juz_amma_puzzle/ui/theme.dart';

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
  final TextStyle captionStyle =
      TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[800]);
}

class _FeedbackFormState extends State<FeedbackForm> {
  List<String> attachments = [];
  bool isHTML = false;
  String recipient = 'alza.interactive@gmail.com';
  String subject = 'Masukan/saran untuk aplikasi Al Qur\'an Puzzle';

  final _bodyController = TextEditingController(
    text: 'Isi saran/masukan anda disini',
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: _appBar(),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.attachment),
          label: Text('Lampiran'),
          onPressed: _openImagePicker,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _bodyEmailRecipient(),
                    _bodyEmailSubject(),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _bodyController,
                        maxLines: 10,
                        decoration: InputDecoration(
                            labelText: 'Saran/Masukan',
                            border: OutlineInputBorder()),
                      ),
                    ),
                    _bodyEmailAttachments()
                  ],
                ))));
  }

  Widget _appBar() {
    return AppBar(
      title: Text(
        'Kirim saran/masukan ',
        style: AppTheme.appBarTitleStyle(),
      ),
      actions: <Widget>[
        IconButton(
          color: Colors.white,
          onPressed: send,
          icon: Icon(Icons.send),
        )
      ],
    );
  }

  Widget _bodyEmailRecipient() {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Text('Tujuan: ', style: widget.captionStyle),
            Text(recipient)
          ],
        ));
  }

  Widget _bodyEmailSubject() {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Text('Judul: ', style: widget.captionStyle),
            Text(subject)
          ],
        ));
  }

  Widget _bodyEmailAttachments() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Daftar lampiran:',
            style: widget.captionStyle,
          ),
          Column(
            children: attachments
                .map(
                  (item) => Text(
                    item,
                    overflow: TextOverflow.fade,
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: subject,
      recipients: [recipient],
      attachmentPaths: attachments,
      isHTML: isHTML,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }

  void _openImagePicker() async {
    PickedFile pick = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        attachments.add(pick.path);
      }
    });
  }
}
