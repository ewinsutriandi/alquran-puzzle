import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:juz_amma_puzzle/model/game_stats.dart';
import 'package:juz_amma_puzzle/model/quran.dart';
import 'package:juz_amma_puzzle/services/stats_api.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ListSuraProgressAll extends StatefulWidget {
  final Color _darkColor = Colors.blue[300];
  final Color _lightColor = Colors.blue[50];
  final List<Sura> suraList;
  ListSuraProgressAll({this.suraList});
  
  final TextStyle captionStyle = TextStyle(
    color: Colors.white,    
    fontSize: 14.0,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w500
  );

  @override
  ListSuraProgressAllState createState() => ListSuraProgressAllState();

}

class ListSuraProgressAllState extends State<ListSuraProgressAll> {
  Future<StatsGroup> _statsF;  
  @override
  void initState() {
    super.initState();          
  }

  Widget _progressCardSura(StatsGroup stats) {
    int pct = (stats.progressSura * 100).round();
    return Container(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularPercentIndicator(
            animation: true,
            animationDuration: 500,
            radius: 65,
            center: Text('$pct%',style: widget.captionStyle,),
            //fillColor: Colors.white,
            backgroundColor: Colors.white54,     
            progressColor: Colors.white,
            lineWidth: 11,
            circularStrokeCap: CircularStrokeCap.round,
            percent: stats.progressSura,
          ),          
          Text('Surat',style: widget.captionStyle,),          
          Text('${stats.suraSolved}/${stats.totalSura}',style: widget.captionStyle,),
          SizedBox(
            height: 4,
          ),
        ]
      ),
    );
  }

  Widget _progressCardAya(StatsGroup stats) {
    int pct = (stats.progressAya * 100).round();
    return Container(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularPercentIndicator(
            animation: true,
            animationDuration: 500,
            radius: 65,
            center: Text('$pct%',style: widget.captionStyle,),
            //fillColor: Colors.white,
            backgroundColor: Colors.white54,     
            progressColor: Colors.white,
            lineWidth: 11,
            circularStrokeCap: CircularStrokeCap.round,
            percent: stats.progressAya,
          ),          
          Text('Ayat',style: widget.captionStyle,),          
          Text('${stats.ayaSolved}/${stats.totalAya}',style: widget.captionStyle,),
          SizedBox(
            height: 4,
          ),
        ]
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {        
    _statsF = GetIt.I<StatsAPI>().getStatsGroup(widget.suraList);
    return Container(      
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: FutureBuilder(
        future: _statsF,
        builder: (context, snapshot) {
           if (snapshot.hasData) {
             StatsGroup data = snapshot.data;             
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _progressCardSura(data),
                  SizedBox(width:16),
                  _progressCardAya(data),                
                ],
              );             
           } else {
             return Center(
               child: CircularProgressIndicator(),
             );
           }   
        },
        )
    );
  }
}