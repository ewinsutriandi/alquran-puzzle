import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:juz_amma_puzzle/services/quran_api.dart';
import 'package:juz_amma_puzzle/services/service_locator.dart';
import 'package:juz_amma_puzzle/ui/home.dart';
//import 'package:juz_amma_puzzle/engine/jumbled.dart';
import 'package:juz_amma_puzzle/ui/theme.dart';

import 'model/quran.dart';

void main() {    
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {    
  _MyAppState createState() => _MyAppState();
  
}

class _MyAppState extends State<MyApp> {  
  int _pgIdx=0;  
  
  @override
  void initState() {
    super.initState();
    GetIt.I<QuranAPI>().getSuraList();    
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
      print('switch to: '+index.toString());
      _pgIdx = index;
    });
  }

  List<Widget> pages = [
    Container(
      child: Home(),
    ),
    Container(
      color: Colors.blue,
    ),
    Container(
      color: Colors.green,
    ),
    Container(
      color: Colors.white,
    ),
  ];

  Widget bottomBar() {
    Color fgColor = Colors.white;
    Color barColor = Colors.orange; 
    return CurvedNavigationBar (
      color: barColor,      
      backgroundColor: fgColor,
      height: 50,
      buttonBackgroundColor: Colors.deepOrange,
      animationDuration: Duration(milliseconds: 250),      
      items: <Widget>[
        Icon(Icons.home, color:fgColor),
        Icon(Icons.help, color:fgColor),
        Icon(Icons.settings, color:fgColor),
        Icon(Icons.share, color:fgColor),
      ],
      onTap: (index) {
        _switchPage(index);        
      },
    );
  }
}


