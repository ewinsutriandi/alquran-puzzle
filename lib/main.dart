import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:juz_amma_puzzle/data/quran_data.dart';
import 'package:juz_amma_puzzle/services/service_locator.dart';
import 'package:juz_amma_puzzle/ui/feedback/email_feedback.dart';
import 'package:juz_amma_puzzle/ui/home/home.dart';
import 'package:juz_amma_puzzle/ui/theme.dart';

void main() async {
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _pgIdx = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.normalTheme(),
      home: _pageScaffold(pages[_pgIdx]),
    );
  }

  Widget _pageScaffold(Widget pg) {
    return Scaffold(
      appBar: AppTheme.appBar(),
      body: pg,
      bottomNavigationBar: bottomBar(),
    );
  }

  void _switchPage(index) {
    setState(() {
      print('switch to: ' + index.toString());
      _pgIdx = index;
    });
  }

  List<Widget> pages = [
    Container(
      child: FutureBuilder(
        future: GetIt.I<QuranData>().onReady,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Home();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    ),
    _underConstruction(),
    FeedbackForm(),
    _underConstruction(),
  ];

  static Widget _underConstruction() {
    return Container(
      child: Center(
        child: Text('Fitur belum tersedia dalam versi ujicoba ini'),
      ),
    );
  }

  Widget bottomBar() {
    Color fgColor = Colors.white;
    Color barColor = Colors.orange;
    return CurvedNavigationBar(
      color: barColor,
      backgroundColor: fgColor,
      height: 50,
      buttonBackgroundColor: Colors.deepOrange,
      animationDuration: Duration(milliseconds: 250),
      items: <Widget>[
        Icon(Icons.home, color: fgColor),
        Icon(Icons.help, color: fgColor),
        Icon(Icons.add_comment, color: fgColor),
        Icon(Icons.share, color: fgColor),
      ],
      onTap: (index) {
        _switchPage(index);
      },
    );
  }
}
