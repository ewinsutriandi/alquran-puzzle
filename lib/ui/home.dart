import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:juz_amma_puzzle/components/hello.dart';
import 'package:juz_amma_puzzle/components/last_session.dart';
import 'package:juz_amma_puzzle/components/progress_all.dart';
import 'package:juz_amma_puzzle/components/progress_juz.dart';
import 'package:juz_amma_puzzle/components/recommend.dart';

class Home extends StatefulWidget {
  static String _userName  = 'Pengguna Baru';
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final TextStyle _captionStyle = TextStyle(
    color: Colors.indigo[700],    
    fontSize: 14.0,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w500
  );
  @override
  Widget build(BuildContext context) {    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 16,),
          Hello(Home._userName),
          _caption('PROGRESS'),          
          Row(
            children: <Widget>[
              Expanded(child: ProgressJuzAmma(490, 2500)),
              SizedBox(width: 8,),
              Expanded(child: MainProgress(1972, 2500)),
            ],
          ),          
          _caption('SESI TERAKHIR'),          
          LastSession(),
          _caption('REKOMENDASI'),
          Recommend()                    
        ],
      ),
    );    
  }

  Widget _caption(String text) {
    return Container(
      padding: EdgeInsets.fromLTRB(4, 12, 8, 4),
      child: 
        Text(text,style: _captionStyle,),      
    );
  }
}