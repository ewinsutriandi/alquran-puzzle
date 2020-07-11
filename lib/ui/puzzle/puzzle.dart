import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:juz_amma_puzzle/engine/jumbled.dart';
import 'package:juz_amma_puzzle/model/game_stats.dart';
import 'package:juz_amma_puzzle/model/quran.dart';
import 'package:juz_amma_puzzle/services/stats_api.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:reorderables/reorderables.dart';

import '../theme.dart';

class SuraPuzzlePage extends StatefulWidget {
  final Sura sura;
  @override
  SuraPuzzlePageState createState() => SuraPuzzlePageState();
  const SuraPuzzlePage({@required this.sura});  
  
}

class SuraPuzzlePageState extends State<SuraPuzzlePage> {
  Sura _sura;
  Future<StatsSura> _statsSura;
  JumbledTextPuzzle _puzzle;
  ScreenStatus _screenStatus;
  List<Widget> _tiles;
  int currentPosition = 0;
  @override
  
  initState() {
    super.initState();    
    _sura = widget.sura;
    _statsSura = GetIt.I<StatsAPI>().getSuraStats(_sura);
    _puzzle = JumbledTextPuzzle(_sura.contents);
    _puzzle.onCheck.listen(this._postCheck);
    newPuzzle();
  }

  void newPuzzle() {
    debugPrint('new puzzle');
    currentPosition++;
    _puzzle.newGame();
    _screenStatus = ScreenStatus.showpuzzle;
    _prepareTiles();
    setState(() {
      
    });    
  }

  @override
  Widget build(BuildContext context) {
    return _pageScaffold(_sliver());
  }

  Widget _pageScaffold(Widget pg) {
    return Scaffold(
      body: pg,
      //bottomNavigationBar: _navigationBar(),   
    );
  }

  Widget _sliver() {
    return CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Surat ${_sura.tIndonesia}',style: AppTheme.appBarTitleStyle(),),
            centerTitle: true,            
            pinned: true,            
            forceElevated: true,            
          ),          
          SliverToBoxAdapter(
            child: _suraProgress(),
          ), 
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 8 , 16, 8),
            sliver: SliverToBoxAdapter(
              child:_navigationBar()
            ),
          ),
          SliverToBoxAdapter(
            child: _position(),
          ),
          
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 16 , 16, 4),
            sliver: SliverToBoxAdapter(
              child: _mainScreen(),              
            ),
          )
          //*/
                                      
        ],
      );
  }

  Widget _suraInfo() {    
    return Container(
      padding: EdgeInsets.fromLTRB(16,4,16,4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircularProgressIndicator(

          ),
          Text(_sura.name,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold
              ),
          ),
          Text('${_sura.trIndonesia}, '),
          Text('${_sura.typeIndonesia}, '),
          Text('Terdiri atas ${_sura.totalAyas} ayat '),          
        ],
      ),
    );
  }

  Widget _suraProgress() {
    return FutureBuilder(
      future: _statsSura,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          StatsSura st = snapshot.data;
          return Container(            
            padding: EdgeInsets.fromLTRB(24,8,24,4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(_sura.name,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold
                      ),
                  ),                                
                LinearPercentIndicator(                  
                  width: 175,
                  lineHeight: 15,
                  //animation: true,
                  animationDuration: 1000,
                  alignment: MainAxisAlignment.center,                  
                  progressColor: Colors.green,
                  percent: st.progress,                  
                ),
                SizedBox(
                  height: 4
                ),                
                Text('Sudah diselesaikan: ${st.ayaSolved} dari ${st.totalAya} ayat')
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },      
    );    
  }

  Widget _position() {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(child: child, scale: animation);
        },
        child: Center(
          child:Text('Ayat $currentPosition dari ${_sura.totalAyas}')
        )
      );          
  }

  Widget _navigationBar() {
    double iconSize = 16;
    Color iconColor = Colors.deepOrange;
    return Container(
      //padding: EdgeInsets.all(4),      
      decoration: BoxDecoration(
        color: Colors.grey[200],
        //borderRadius: BorderRadius.circular(8)
      ),
      child: Row(        
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            color: iconColor,
            iconSize: iconSize,
            icon: Icon(Icons.first_page),
            tooltip: 'ke ayat pertama',
            onPressed: () {
              
            },
          ),
          IconButton(
            color: iconColor,
            iconSize: iconSize,
            icon: Icon(Icons.navigate_before),
            tooltip: 'ke ayat pertama',
            onPressed: () {
              
            },
          ),
          IconButton(
            color: iconColor,
            iconSize: iconSize,
            icon: Icon(Icons.shuffle),
            tooltip: 'ke ayat yang belum diselesaikan',
            onPressed: () {
              
            },
          ),          
          IconButton(
            color: iconColor,
            iconSize: iconSize,
            icon: Icon(Icons.navigate_next),
            tooltip: 'ke ayat terakhir',
            onPressed: () {
              
            },
          ),
          IconButton(
            color: iconColor,
            iconSize: iconSize,
            icon: Icon(Icons.last_page),
            tooltip: 'ke ayat terakhir',
            onPressed: () {
              
            },
          ),  
        ],
      )
    );    
  }

  Widget _hint() {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Center(
        child: Text('Tahan dan geser potongan ayat yang ada untuk memindahkannya sesuai urutan seharusnya', textAlign: TextAlign.center,)
      ),
    );
  }

  Widget _mainScreen() {
    Widget main;
    if (_screenStatus == ScreenStatus.showoritext) {
      main = _originalText();
    } else {
      main = Column(
        children: <Widget>[          
          _choppedText()
        ],
      );
    }   
    return
      AnimatedSwitcher(
        duration: const Duration(seconds: 1),                
        transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation,);
          },          
        child: main,
      );    
  }

  Widget _originalText() {
    bool endOfSura = _puzzle.endOfIdx;    
    TextStyle puzzleTextStyle = TextStyle(
      fontSize: 25.0,
      letterSpacing: 1.5,
      color: Colors.orange,
      fontWeight: FontWeight.bold
    );

    return Container(
      padding: EdgeInsets.fromLTRB(8, 24, 8, 24),
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Column(
        children: <Widget>[
          Icon(Icons.thumb_up,color: Colors.green,size: 25),
          SizedBox(height: 8,),
          Row(                        
            children: <Widget>[
            Expanded(child: Text(_puzzle.originalText(),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: puzzleTextStyle,))
            ],
          ),
          SizedBox(height: 8,),
          RaisedButton(            
            child: Text(endOfSura?'Kembali':'Lanjut',),
            //color: Colors.orange,
            onPressed: () {
              if (endOfSura) {
                Navigator.of(context).pop();
              } else {
                newPuzzle();
              }
            }
          ),
        ],
      )            
    );    
  }

  Widget _choppedText() {
    Widget reorWrap = ReorderableWrap(        
      spacing: 8.0,
      runSpacing: 4.0,
      padding: const EdgeInsets.all(8),
      textDirection: TextDirection.rtl,
      children: _tiles,        
      onReorder: _onReorder,
      onNoReorder: (int index) {        
        debugPrint(
            '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
      },
      onReorderStarted: (int index) {        
        debugPrint(
            '${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
        }
    );
    
    Widget col = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
            _hint(),
            reorWrap 
          ],
      );

    return Container(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.orange[50]
      ),
      child: col,
    );
     
  }

  void _prepareTiles() {
    TextStyle puzzleTextStyle = TextStyle(
      fontSize: 21.0,
      letterSpacing: 1.5,
      color: Colors.white
    );
    _tiles = _puzzle.choppedTexts.map((txt) {
      return Chip(
        key: ValueKey(txt),
        label: Text(txt),
        labelStyle: puzzleTextStyle,
        backgroundColor: Colors.orange,
      );
    }).toList();
  }

  void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        Widget row = _tiles.removeAt(oldIndex);
        _tiles.insert(newIndex, row);
        _puzzle.reorder(oldIndex, newIndex);
      });
    }
  
  void _postCheck(bool correct) {
    if (correct) {
      print('correct');
      GetIt.I<StatsAPI>().recordCompletion(_sura, _puzzle.currentIdx).then((value) {
        _statsSura = GetIt.I<StatsAPI>().getSuraStats(_sura);
      });            
      setState(() {
        _screenStatus = ScreenStatus.showoritext;
      });      
    }
  }
}

enum ScreenStatus {
  showpuzzle,showoritext
}