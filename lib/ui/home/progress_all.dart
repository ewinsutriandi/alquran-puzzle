import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:juz_amma_puzzle/data/quran_data.dart';
import 'package:juz_amma_puzzle/model/game_stats.dart';
import 'package:juz_amma_puzzle/services/stats_api.dart';
import 'package:juz_amma_puzzle/ui/list_sura/list_sura_page.dart';
import 'package:juz_amma_puzzle/ui/theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MainProgress extends StatefulWidget {
  BuildContext _context;
  Color _bgColor = Colors.blue;
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

  @override
  MainProgressState createState() => MainProgressState();

}

class MainProgressState extends State<MainProgress> { 
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetIt.I<QuranData>().suraList.then((value) => GetIt.I<StatsAPI>().getStatsGroup(value)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          StatsGroup stats = snapshot.data;
          return Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            decoration: BoxDecoration(
              color: widget._bgColor,        
              border: Border.all(
                color: widget._bgColor,
              ),
              borderRadius: BorderRadius.all(Radius.circular(16))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('KESELURUHAN',style: widget.captionStyle,),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: <Widget>[
                    _progressPct(stats.progressAya),
                    SizedBox(width: 6,),
                    _progressCnt(stats)
                  ],
                )
              ]
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      },    
    );
    
  }

  Widget _progressPct(completion) {
    int pct = (completion * 100).round();
    return CircularPercentIndicator(
      animation: true,
      animationDuration: 500,
      radius: 65,
      center: Text('$pct%',style: widget.tuntasStyle,),
      //fillColor: Colors.white,
      backgroundColor: Colors.white54,     
      progressColor: Colors.white,
      lineWidth: 11,
      circularStrokeCap: CircularStrokeCap.round,
      percent: completion,
    );
  }

  Widget _progressCnt(StatsGroup stats) {
    int pct = (stats.progressAya * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //Text('$pct% ',style: tuntasStyle,),
        Text('${stats.ayaSolved}/6236',style: widget.cntStyle,),
        Text('${stats.gamePlayed} sesi',style: widget.cntStyle,),
        _openList()
        
      ],
    );
  }

  Widget _openList() {
    return ButtonTheme(
        minWidth: 50.0,
        height: 25,        
        child: RaisedButton(
          onPressed: () {
            print('open list sura all');            
            Navigator.push(
              context,
              AppRouteTransition(toPage: ListSuraPage())
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),          
          child:Text('Lihat',style: TextStyle(color: widget._bgColor),),
          color: Colors.grey[100],
        ),
      );
  }
}