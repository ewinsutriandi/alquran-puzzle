import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:juz_amma_puzzle/data/quran_data.dart';
import 'package:juz_amma_puzzle/engine/jumbled.dart';
import 'package:juz_amma_puzzle/model/game_stats.dart';
import 'package:juz_amma_puzzle/model/quran.dart';
import 'package:juz_amma_puzzle/services/stats_api.dart';
import 'package:juz_amma_puzzle/ui/jumbled_text_page.dart';
import 'package:juz_amma_puzzle/ui/list_sura/list_sura_progress_all.dart';
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

  final TextStyle _transliterationStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey[600]        
  );

  final TextStyle _statstyle = TextStyle(
    fontSize: 14,    
    fontStyle: FontStyle.italic,
    color: Colors.grey[700]        
  );
  State<StatefulWidget> createState() => ListSuraPageState();
     
}

class ListSuraPageState extends State<ListSuraPage> {
  Future<List<Sura>> _suraList;
  static BuildContext _context;

  @override
  void initState() {
    super.initState();
    _suraList = GetIt.I<QuranData>().suraList;
  }
  
  @override
  Widget build(BuildContext context) {    
    _context = context;
    return _pageScaffold(
      FutureBuilder(
        future: _suraList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _sliver(snapshot.data);
          } else {
            return
              Center(
                child: CircularProgressIndicator(),
              );
          }
        },
        )
    );
  }

  Widget _pageScaffold(Widget pg) {
    return Scaffold(
      //appBar: AppTheme.appBar(),
      drawerScrimColor: widget._darkColor,      
      body: pg,
      //bottomNavigationBar: bottomBar(),      
    );
  }

  Widget _sliver(List<Sura> data) {
    return CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Keseluruhan surat',style: AppTheme.appBarTitleStyle(),),
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
              color: Colors.orange[700],
              padding: const EdgeInsets.all(8.0),
              child: ListSuraProgressAll(suraList: data),              
            ),            
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 60, 
              maxHeight: 60, 
              child: Container(
                color: Colors.orange,
                padding: const EdgeInsets.all(8.0),
                child: _search(),              
              ),
            )
          ),          
          SliverPadding(
            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                data.map((s) => _progressSura(s)).toList()
              )              
            ),
            
          ),
                   
        ],
      );

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
            progressIcon = Icon(Icons.check_circle,color:pctColor,size: 25,);                              
          } else {
            if (st.progress>0.75) {
              pctColor = Colors.yellowAccent[700];
            } else if (st.progress>0.50) {
              pctColor = Colors.yellow;
            } else if (st.progress>0.25){
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

          return Container(
            //padding: EdgeInsets.fromLTRB(16, 8, 16, 8),      
            padding: EdgeInsets.only(bottom: 4,top: 4),
            child: Container(
              decoration: BoxDecoration(
                color: pctColor,                
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),          
                )
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width:4,
                    child: null             
                    ),
                  Expanded(
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(child:_suraDetails(s,st)),
                          progressIcon
                        ],
                      ),
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                        color: Colors.white,                
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),                              
                        ),
                        border: new Border.all(
                          color: Colors.grey,
                          width: 0.7,
                          style: BorderStyle.solid
                        ),                  
                      ),
                    ),
                  ),
                        
                ],
              ),
            )
          );
        }
        else {
          return CircularProgressIndicator();
        }
      },
    );
    
  }

  Widget _suraDetails(Sura sura,StatsSura stats) {                
    return Column(                
        crossAxisAlignment: CrossAxisAlignment.start,          
        children: <Widget>[
          Text(
            sura.name,
            //textDirection: TextDirection.rtl,
            style: widget._titleStyle,          
          ),
          Text(
            sura.tIndonesia+' - '+sura.trIndonesia, 
            style: widget._transliterationStyle,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            sura.typeIndonesia,
            style: widget._transliterationStyle,
          ),                      
          SizedBox(
            height: 4
          ),
          _progress(stats)           
          ,            
          SizedBox(
            height: 4
          )       
        ]
      );      
  }
  
  Widget _progress(StatsSura st){
    Widget teks = Text("${st.ayaSolved}/${st.totalAya} dalam ${st.gamePlayed} kali bermain",
      overflow: TextOverflow.ellipsis,
      style: widget._statstyle,);     
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("Statistik: ",style: widget._statstyle,),                    
          teks,          
        ],
      );   
  }

  Widget _search() {    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),           
      child: TextField(      
        //controller: _filter,
        decoration: new InputDecoration(
          prefixIcon: new Icon(Icons.search),
          hintText: 'Cari...'
        ),
      ),
    );
    
  }

  void _openSura(Sura s) {
    List<String> ayas = s.contents;
    print(ayas);
    JumbledTextPuzzle _engine = JumbledTextPuzzle(ayas);
    JumbledTextPage puzzle = JumbledTextPage(_engine);
    Widget page = Scaffold(
      appBar: AppBar(
        title: Text('Juz Amma Puzzle'),
        centerTitle: true,
      ),
      body: puzzle,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            title: Text('Awal Surat'),
            icon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
            title: Text('Belum Terselesaikan'),
            icon: Icon(Icons.event_available)
          ),
          BottomNavigationBarItem(
            title: Text('Acak'),
            icon: Icon(Icons.all_inclusive)
          ),
        ],
      ),
    );
    Navigator.push(
      _context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: animation,
            child: child,
            alignment: Alignment.topCenter,
            );
        },
        )
      );
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
      BuildContext context, 
      double shrinkOffset, 
      bool overlapsContent) 
  {
    return new SizedBox.expand(child: child);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}