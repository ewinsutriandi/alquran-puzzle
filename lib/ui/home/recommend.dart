import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:juz_amma_puzzle/model/quran.dart';
import 'package:juz_amma_puzzle/services/recommender.dart';
import 'package:juz_amma_puzzle/ui/puzzle/puzzle.dart';
import 'package:juz_amma_puzzle/ui/theme.dart';

class Recommend extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RecommendState();
}

class RecommendState extends State<Recommend> {
  String lastSura;
  String lastCorrectAya;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Recommender.getRecommendation(3),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Sura> recs = snapshot.data;
          return Container(
            //padding: EdgeInsets.all(0),
            //constraints: BoxConstraints.expand(),
            child: Row(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: SingleRecommendation(
                    sura: recs[0],
                    bgColor: Colors.purple[50],
                    fgColor: Colors.purple[600],
                  )),
                  SizedBox(width: 4),
                  Expanded(
                      child: SingleRecommendation(
                    sura: recs[1],
                    bgColor: Colors.brown[50],
                    fgColor: Colors.brown[600],
                  )),
                  SizedBox(width: 4),
                  Expanded(
                    child: SingleRecommendation(
                      sura: recs[2],
                      bgColor: Colors.indigo[50],
                      fgColor: Colors.indigo[600],
                    ),
                  )
                ]),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class SingleRecommendation extends StatelessWidget {
  final Sura sura;
  final Color bgColor;
  final Color fgColor;
  SingleRecommendation({this.sura, this.bgColor, this.fgColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4, 16, 4, 8),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            sura.name,
            style: TextStyle(
                color: fgColor,
                fontSize: 24.0,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w500),
          ),
          Text(
            sura.tIndonesia,
            overflow: TextOverflow.fade,
            style: TextStyle(
                color: fgColor,
                fontSize: 12.0,
                letterSpacing: 1,
                fontWeight: FontWeight.w400),
          ),
          Text(
            '(${sura.trIndonesia})',
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: TextStyle(
                color: fgColor,
                fontSize: 11.0,
                letterSpacing: 1,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400),
          ),
          ButtonTheme(
            minWidth: 50.0,
            height: 25,
            child: RaisedButton(
              onPressed: () {
                debugPrint('RECOMMEND open recommended sura ${sura.name}');
                SuraPuzzlePage puzzle = SuraPuzzlePage(sura: sura);
                Navigator.push(context, AppRouteTransition(toPage: puzzle));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                'Buka',
                style: TextStyle(color: bgColor),
              ),
              color: fgColor,
            ),
          )
        ],
      ),
    );
  }
}
