import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:juz_amma_puzzle/model/quran.dart';
import 'package:juz_amma_puzzle/services/recommender.dart';
import 'package:juz_amma_puzzle/ui/puzzle/puzzle.dart';
import 'package:juz_amma_puzzle/ui/theme.dart';

class Recommend extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RecommendState();
  final Function callback;
  Recommend(this.callback);
}

class RecommendState extends State<Recommend> {
  String lastSura;
  String lastCorrectAya;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(4, 16, 4, 8),
        decoration: BoxDecoration(
            //color: Colors.indigo[200],
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: _recommendations());
  }

  Widget _recommendations() {
    return FutureBuilder(
      future: Recommender.getRecommendation(3),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Sura> recs = snapshot.data;
          return Row(
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: _recommend(
                  recs[0],
                  Colors.purple[50],
                  Colors.purple[600],
                )),
                SizedBox(width: 4),
                Expanded(
                    child: _recommend(
                  recs[1],
                  Colors.brown[50],
                  Colors.brown[600],
                )),
                SizedBox(width: 4),
                Expanded(
                  child: _recommend(
                    recs[2],
                    Colors.indigo[50],
                    Colors.indigo[600],
                  ),
                )
              ]);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _recommend(Sura sura, Color bgColor, Color fgColor) {
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
                Navigator.push(context, AppRouteTransition(toPage: puzzle))
                    .then((value) => widget.callback());
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
