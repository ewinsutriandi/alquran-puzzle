import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:juz_amma_puzzle/data/quran_data.dart';
import 'package:juz_amma_puzzle/model/game_stats.dart';
import 'package:juz_amma_puzzle/model/quran.dart';
import 'package:juz_amma_puzzle/services/stats_api.dart';

class LastSessionRecord extends StatefulWidget {
  final Color _bgColor = Colors.teal[50];
  final TextStyle suraNameStyle = TextStyle(
      color: Colors.teal[800],
      fontSize: 32.0,
      letterSpacing: 1.5,
      fontWeight: FontWeight.w600);

  final TextStyle suraTrStyle = TextStyle(
      color: Colors.teal[700],
      fontSize: 14.0,
      letterSpacing: 1,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w400);

  final TextStyle cntStyle = TextStyle(
      color: Colors.teal[600],
      fontSize: 16.0,
      letterSpacing: 1.1,
      fontWeight: FontWeight.w500);

  @override
  State<StatefulWidget> createState() => LastSessionRecordState();
}

class LastSessionRecordState extends State<LastSessionRecord> {
  String lastSura;
  String lastCorrectAya;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetIt.I<StatsAPI>().lastSession(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          LastSession ls = snapshot.data;
          return Container(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                  color: widget._bgColor,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: _sessionDetails(ls));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _sessionDetails(LastSession ls) {
    return FutureBuilder(
      future: GetIt.I<QuranData>().getByIndex(ls.suraIdx),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Sura s = snapshot.data;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    s.name,
                    style: widget.suraNameStyle,
                  ),
                  Text(
                    s.tIndonesia,
                    style: widget.suraTrStyle,
                  ),
                  Text(
                    s.trIndonesia,
                    style: widget.suraTrStyle,
                  ),
                ],
              ),
              SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Posisi',
                      style: widget.cntStyle,
                    ),
                    Text(
                      'Ayat ke-${ls.ayaNumber} dari ${s.totalAyas}',
                      style: widget.cntStyle,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 2),
                      alignment: Alignment.bottomRight,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {},
                        child: Text(
                          ls.completed == 1
                              ? 'Buka surat berikutnya'
                              : 'Buka ayat berikutnya',
                          style: TextStyle(color: Colors.teal[800]),
                        ),
                        color: Colors.grey[100],
                      ),
                    ),
                  ],
                ),
              )
            ],
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
