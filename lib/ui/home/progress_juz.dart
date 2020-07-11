import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProgressJuzAmma extends StatelessWidget {
  Color _bgColor = Colors.teal;
  int _solved;
  int _totalPlayed;
  double _pct;

  final TextStyle captionStyle = TextStyle(
    color: Colors.white,    
    fontSize: 14.0,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w500
  );

  final TextStyle cntStyle = TextStyle(
    color: Colors.white70,
    fontSize: 14.0,
    letterSpacing: 1,
    fontWeight: FontWeight.w500
  );

  final TextStyle tuntasStyle = TextStyle(
    color: Colors.white,
    fontSize: 14.0,
    letterSpacing: 1.1,
    fontWeight: FontWeight.w600
  );

  ProgressJuzAmma(int solved, int totalPlayed) {
    this._solved = solved; // distinct
    this._totalPlayed = totalPlayed;
    this._pct = (solved / 553 );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: _bgColor,        
        border: Border.all(
          color: _bgColor,
        ),
        borderRadius: BorderRadius.all(Radius.circular(16))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('JUZ AMMA',style: captionStyle,),
          SizedBox(
            height: 8,
          ),
          Row(
            children: <Widget>[
              _progressPct(),
              SizedBox(width: 6,),
              _progressCnt()
            ],
          )
        ]
      ),
    );
  }

  Widget _progressPct() {
    int pct = (_pct * 100).round();
    return CircularPercentIndicator(
      animation: true,
      animationDuration: 500,
      radius: 65,
      center: Text('$pct%',style: tuntasStyle,),
      //fillColor: Colors.white,
      backgroundColor: Colors.white54,     
      progressColor: Colors.white,
      lineWidth: 11,
      circularStrokeCap: CircularStrokeCap.round,
      percent: _pct,
    );
  }

  Widget _progressCnt() {
    //int pct = (_pct * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //Text('$pct% ',style: tuntasStyle,),
        Text('$_solved / 553',style: cntStyle,),
        Text('$_totalPlayed sesi',style: cntStyle,),
        _openList()
        
      ],
    );
  }

  Widget _openList() {
    return ButtonTheme(
        minWidth: 50.0,
        height: 25,        
        child: RaisedButton(
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),          
          child:Text('Lihat',style: TextStyle(color: _bgColor),),
          color: Colors.grey[100],
        ),
      );    
  }

}