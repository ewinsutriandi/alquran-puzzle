import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:juz_amma_puzzle/ui/feedback/email_feedback.dart';
import 'package:juz_amma_puzzle/ui/home/hello.dart';
import 'package:juz_amma_puzzle/ui/home/last_session.dart';
import 'package:juz_amma_puzzle/ui/home/progress_all.dart';
import 'package:juz_amma_puzzle/ui/home/progress_juz.dart';
import 'package:juz_amma_puzzle/ui/home/recommend.dart';
import 'package:juz_amma_puzzle/ui/theme.dart';

class Home extends StatefulWidget {
  //static String _userName = 'Pengguna Baru';
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final TextStyle _captionStyle = TextStyle(
      color: Colors.indigo[700],
      fontSize: 14.0,
      letterSpacing: 1.2,
      fontWeight: FontWeight.w500);

  reload() {
    debugPrint('HOME: Rebuilding home page');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Hello(),
            _caption('PROGRESS'),
            Row(
              children: <Widget>[
                Expanded(child: ProgressJuzAmma(reload)),
                SizedBox(
                  width: 8,
                ),
                Expanded(child: MainProgress(reload)),
              ],
            ),
            _caption('SESI TERAKHIR'),
            LastSessionRecord(reload),
            _caption('REKOMENDASI'),
            Recommend(reload),
            //_feedback(),
            SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }

  Widget _caption(String text) {
    return Container(
      padding: EdgeInsets.fromLTRB(4, 12, 8, 4),
      child: Text(
        text,
        style: _captionStyle,
      ),
    );
  }

  Widget _feedback() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
          child: ButtonTheme(
        minWidth: 50.0,
        //height: 25,
        child: RaisedButton(
          onPressed: () {
            Navigator.push(context, AppRouteTransition(toPage: FeedbackForm()));
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(
            'Kirim Masukan',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue[500],
        ),
      )),
    );
  }
}
