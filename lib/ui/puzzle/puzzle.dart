import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:juz_amma_puzzle/engine/jumbled.dart';
import 'package:juz_amma_puzzle/model/game_stats.dart';
import 'package:juz_amma_puzzle/model/quran.dart';
import 'package:juz_amma_puzzle/services/stats_api.dart';
import 'package:reorderables/reorderables.dart';

import '../theme.dart';

class SuraPuzzlePage extends StatefulWidget {
  final Sura sura;
  final int ayaNumber;
  @override
  SuraPuzzlePageState createState() => SuraPuzzlePageState();
  const SuraPuzzlePage({@required this.sura, this.ayaNumber});
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
    widget.ayaNumber == null
        ? newPuzzle()
        : newPuzzleFromAya(widget.ayaNumber - 1);
  }

  void newPuzzle() {
    debugPrint('new puzzle');
    currentPosition++;
    _puzzle.newGame();
    _screenStatus = ScreenStatus.showpuzzle;
    _prepareTiles();
    setState(() {});
  }

  void newPuzzleFromAya(int ayaNumber) {
    debugPrint('new puzzle from aya');
    currentPosition = ayaNumber;
    _puzzle.newGameOnTextIdx(currentPosition);
    _screenStatus = ScreenStatus.showpuzzle;
    _prepareTiles();
    setState(() {});
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
          title: Text(
            'Surat ${_sura.tIndonesia}',
            style: AppTheme.appBarTitleStyle(),
          ),
          centerTitle: true,
          pinned: true,
          forceElevated: true,
        ),
        SliverToBoxAdapter(
          child: _suraInfo(),
        ),
        SliverToBoxAdapter(
          child: _suraProgress(),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
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
      padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            _sura.name,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text('${_sura.trIndonesia} '),
          Text('${_sura.totalAyas} ayat, ${_sura.typeIndonesia}'),
        ],
      ),
    );
  }

  Widget _suraProgress() {
    TextStyle progressTxtStyle = TextStyle(fontSize: 12.0, color: Colors.white);
    return FutureBuilder(
      future: _statsSura,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          StatsSura st = snapshot.data;
          return Container(
            //padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Row(
              //crossAxisAlignment: WrapCrossAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                st.completed
                    ? Chip(
                        label: Text('Tamat ${st.completionCount} kali'),
                        backgroundColor: Colors.green,
                        labelStyle: progressTxtStyle,
                      )
                    : Chip(
                        label: Text('Sudah diselesaikan: ${st.ayaSolved} ayat'),
                        backgroundColor: Colors.blueGrey,
                        labelStyle: progressTxtStyle,
                      ),
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
        child: Container(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 4),
            decoration: BoxDecoration(color: Colors.orange[50]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 27,
                ),
                Center(
                  child: Text('Ayat ke-$currentPosition'),
                ),
                SizedBox(
                  width: 4,
                ),
                _simplePopup()
              ],
            )));
  }

  Widget _simplePopup() {
    return FutureBuilder(
      future: _statsSura,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          StatsSura stats = snapshot.data;
          return PopupMenuButton<int>(
            child: Chip(
              label: Icon(
                Icons.code,
                size: 19,
                color: Colors.orange,
              ),
              backgroundColor: Colors.white,
            ),
            itemBuilder: (context) => _popupMenuItemBuilder(),
            onSelected: (value) {
              int gotoIdx = 0;
              if (value == 0) {
                if (_puzzle.currentIdx > 0) {
                  gotoIdx = _puzzle.currentIdx - 1;
                } else {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Sudah di awal surat')));
                  return;
                }
              } else if (value == 1) {
                if (_puzzle.currentIdx > 0) {
                  gotoIdx = _puzzle.currentIdx - 1;
                } else {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Sudah di awal surat')));
                  return;
                }
              } else if (value == 2) {
                if (!_puzzle.endOfIdx) {
                  gotoIdx = _puzzle.currentIdx + 1;
                } else {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Sudah di akhir surat')));
                  return;
                }
              } else if (value == 3) {
                if (!stats.completed) {
                  gotoIdx = stats.firstUncomplete;
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Seluruh ayat sudah diselesaikan')));
                  return;
                }
              } else if (value == 4) {
                if (!_puzzle.endOfIdx) {
                  gotoIdx = stats.totalAya - 1;
                } else {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Sudah di akhir surat')));
                  return;
                }
              }
              debugPrint('Jump to verse index $gotoIdx');
              setState(() {
                newPuzzleFromAya(gotoIdx);
              });
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  List<PopupMenuEntry> _popupMenuItemBuilder() {
    List<PopupMenuEntry<int>> items = [];
    List<String> captions = [
      'Awal surat',
      'Ayat sebelumnya',
      'Ayat berikutnya',
      'Ayat yang belum diselesaikan',
      'Akhir surat'
    ];
    List<IconData> icons = [
      Icons.first_page,
      Icons.navigate_before,
      Icons.navigate_next,
      Icons.compare_arrows,
      Icons.last_page
    ];
    for (int i = 0; i < captions.length; i++) {
      items.add(PopupMenuItem(
        height: 33,
        value: i,
        child: Row(
          children: <Widget>[
            Icon(
              icons[i],
              size: 17,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              captions[i],
              style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
            )
          ],
        ),
      ));
    }
    return items;
  }

  Widget _hint() {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 4),
      child: Center(
          child: Text(
        'Tahan dan geser potongan ayat yang ada untuk memindahkannya sesuai urutan seharusnya',
        textAlign: TextAlign.center,
      )),
    );
  }

  Widget _mainScreen() {
    Widget main;
    if (_screenStatus == ScreenStatus.showoritext) {
      main = _originalText();
    } else {
      main = Column(
        children: <Widget>[_choppedText()],
      );
    }
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          child: child,
          //turns: animation,
          scale: animation,
        );
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
        fontWeight: FontWeight.bold);

    return Container(
        padding: EdgeInsets.fromLTRB(8, 24, 8, 24),
        decoration: BoxDecoration(color: Colors.orange[50]),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Ayat ke-$currentPosition'),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  _puzzle.originalText(),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: puzzleTextStyle,
                )),
              ],
            ),
            Text(
              _sura.contentsTrans[currentPosition - 1],
              textAlign: TextAlign.center,
              //style: puzzleTextStyle,
            ),
            SizedBox(
              height: 8,
            ),
            RaisedButton(
                child: Text(
                  endOfSura ? 'Kembali' : 'Lanjut',
                ),
                color: Colors.white,
                onPressed: () {
                  if (endOfSura) {
                    Navigator.of(context).pop();
                  } else {
                    newPuzzle();
                  }
                }),
          ],
        ));
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
        });

    Widget col = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[_position(), _hint(), reorWrap],
    );

    return Container(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(color: Colors.orange[50]),
      child: col,
    );
  }

  void _prepareTiles() {
    TextStyle puzzleTextStyle =
        TextStyle(fontSize: 21.0, letterSpacing: 1.5, color: Colors.white);
    _tiles = _puzzle.choppedTexts.map((txt) {
      //debugPrint('text: $txt');
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
      GetIt.I<StatsAPI>()
          .recordCompletion(_sura, _puzzle.currentIdx, _puzzle.endOfIdx)
          .then((value) {
        _statsSura = GetIt.I<StatsAPI>().getSuraStats(_sura);
        setState(() {
          _screenStatus = ScreenStatus.showoritext;
        });
      });
    }
  }
}

enum ScreenStatus { showpuzzle, showoritext }
