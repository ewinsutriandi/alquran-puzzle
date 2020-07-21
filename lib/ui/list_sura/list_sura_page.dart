import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:juz_amma_puzzle/data/quran_data.dart';
import 'package:juz_amma_puzzle/model/game_stats.dart';
import 'package:juz_amma_puzzle/model/quran.dart';
import 'package:juz_amma_puzzle/services/stats_api.dart';
import 'package:juz_amma_puzzle/ui/list_sura/list_sura_progress_all.dart';
import 'package:juz_amma_puzzle/ui/puzzle/puzzle.dart';
import 'package:juz_amma_puzzle/ui/theme.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math' as math;

class ListSuraPage extends StatefulWidget {
  @override
  final Color _darkColor = Colors.blue;
  final Color _lightColor = Colors.blue[50];

  final TextStyle _pageTitleStyle = TextStyle(
    fontSize: 37,
    //color: Colors.blue[700],
    fontWeight: FontWeight.w600,
  );

  final TextStyle _titleStyle = TextStyle(
    fontSize: 27,
    //color: Colors.blue[700],
    fontWeight: FontWeight.w600,
  );

  final TextStyle _transliterationStyle =
      TextStyle(fontSize: 14, color: Colors.black);

  final TextStyle _statstyle = TextStyle(
      fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[700]);
  State<StatefulWidget> createState() => ListSuraPageState();
}

class ListSuraPageState extends State<ListSuraPage> {
  List<Sura> _suraList;
  String _searchPhrase;
  TextEditingController _searchController = TextEditingController();
  int _suraFound;

  @override
  void initState() {
    super.initState();
    _suraList = GetIt.I<QuranData>().suraList;
    _searchController.addListener(() {
      debugPrint(_searchController.text);
      _searchPhrase = _searchController.text.toLowerCase();
      setState(() {});
    });
  }

  Future<List<Sura>> get _filteredList async {
    List<Sura> filtered = [];
    if (_searchPhrase == null || _searchPhrase.isEmpty) {
      filtered = _suraList;
    } else {
      _suraFound = 0;
      for (int i = 0; i < _suraList.length; i++) {
        Sura s = _suraList[i];
        if (s.name.toLowerCase().contains(_searchPhrase) ||
            s.tEnglish.toLowerCase().contains(_searchPhrase) ||
            s.tIndonesia.toLowerCase().contains(_searchPhrase) ||
            s.trIndonesia.toLowerCase().contains(_searchPhrase) ||
            s.trEnglish.toLowerCase().contains(_searchPhrase) ||
            s.typeIndonesia.toLowerCase().contains(_searchPhrase) ||
            s.type.toLowerCase().contains(_searchPhrase)) {
          filtered.add(s);
          _suraFound++;
        }
      }
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return _pageScaffold(FutureBuilder(
      future: _filteredList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _sliver(snapshot.data);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }

  Widget _pageScaffold(Widget pg) {
    return Scaffold(
      //appBar: AppTheme.appBar(),
      //drawerScrimColor: widget._darkColor,
      body: pg,
      //bottomNavigationBar: bottomBar(),
    );
  }

  Widget _sliver(List<Sura> data) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text(
            'Keseluruhan surat',
            style: AppTheme.appBarTitleStyle(),
          ),
          centerTitle: true,
          pinned: true,
          //floating: false,
          forceElevated: true,
          //expandedHeight: 48.0,
          flexibleSpace: FlexibleSpaceBar(

              //background: ListSuraProgressAll(suraList: data),
              ),
        ),
        SliverToBoxAdapter(
          child: Container(
              color: widget._darkColor,
              padding: const EdgeInsets.all(8.0),
              child: ListSuraProgressAll(suraList: _suraList)),
        ),
        SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 60,
              maxHeight: 60,
              child: Container(
                color: widget._darkColor,
                padding: const EdgeInsets.all(8.0),
                child: _search(),
              ),
            )),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
          sliver: SliverList(delegate: _suraProgressList(data)),
        ),
      ],
    );
  }

  SliverChildListDelegate _suraProgressList(List<Sura> data) {
    if (data.length > 0) {
      return SliverChildListDelegate(
          data.map((s) => _progressSura(s)).toList());
    } else {
      return SliverChildListDelegate([Text('Data tidak ditemukan')]);
    }
  }

  Widget _progressSura(Sura s) {
    return FutureBuilder(
      future: GetIt.I<StatsAPI>().getSuraStats(s),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          StatsSura st = snapshot.data;
          Color pctColor = Colors.red;
          Widget progressIcon;
          if (st.completed) {
            pctColor = Colors.green[700];
            progressIcon = Icon(
              Icons.check_circle,
              color: pctColor,
              size: 25,
            );
          } else {
            if (st.progress > 0.75) {
              pctColor = Colors.yellowAccent[700];
            } else if (st.progress > 0.50) {
              pctColor = Colors.yellow;
            } else if (st.progress > 0.25) {
              pctColor = Colors.orange;
            }
            progressIcon = CircularPercentIndicator(
              animation: true,
              animationDuration: 500,
              radius: 25,
              //center: Text('$pct%'),
              //fillColor: Colors.white,
              backgroundColor: widget._lightColor,
              progressColor: pctColor,
              lineWidth: 5,
              circularStrokeCap: CircularStrokeCap.round,
              percent: st.progress,
            );
          }
          return GestureDetector(
            onTap: () => _openSura(s),
            child: Container(
                //padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                padding: EdgeInsets.only(bottom: 4, top: 4),
                child: Container(
                  decoration: BoxDecoration(
                      color: widget._darkColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      border: new Border.all(
                          color: widget._darkColor,
                          width: 0.7,
                          style: BorderStyle.solid)),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 4, child: null),
                      Expanded(
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(child: _suraDetails(s, st)),
                              progressIcon
                            ],
                          ),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          decoration: BoxDecoration(
                            //color: widget._lightColor,
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _suraDetails(Sura sura, StatsSura stats) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sura.name,
            //textDirection: TextDirection.rtl,
            style: widget._titleStyle,
          ),
          Text(
            sura.tIndonesia + ' - ' + sura.trIndonesia,
            style: widget._transliterationStyle,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            sura.typeIndonesia,
            style: widget._transliterationStyle,
          ),
          SizedBox(height: 4),
          _progress(stats),
          SizedBox(height: 4)
        ]);
  }

  Widget _progress(StatsSura st) {
    Widget teks = Text(
      "${st.ayaSolved}/${st.totalAya} dalam ${st.gamePlayed} kali bermain",
      overflow: TextOverflow.ellipsis,
      style: widget._statstyle,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "Statistik: ",
          style: widget._statstyle,
        ),
        teks,
      ],
    );
  }

  Widget _search() {
    String hint = '';
    if (_searchPhrase != null && _searchPhrase.isNotEmpty) {
      hint = '$_suraFound surat ditemukan ';
    }
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Stack(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: new InputDecoration(
                  prefixIcon: new Icon(Icons.search), hintText: 'Cari...'),
            ),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  hint,
                  style: TextStyle(
                      color: Colors.grey[300], fontStyle: FontStyle.italic),
                )
              ],
            ))
          ],
        ));
  }

  void _openSura(Sura s) {
    print('open sura ${s.name}');
    SuraPuzzlePage puzzle = SuraPuzzlePage(sura: s);
    Navigator.push(context, AppRouteTransition(toPage: puzzle)).then((value) {
      setState(() {
        //_progressSummary;
      });
    });
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
