import 'package:flutter/material.dart';
import 'package:juz_amma_puzzle/engine/jumbled.dart';
import 'package:reorderables/reorderables.dart';

class JumbledTextPage extends StatefulWidget {
  final JumbledTextPuzzle _engine;
  JumbledTextPage(this._engine);
  @override
  State<StatefulWidget> createState() => _JumbledTextPageState();
}

class _JumbledTextPageState extends State<JumbledTextPage> {
  //bool _showNewGame;
  bool _showOriginalText=false;
  
  static TextStyle puzzleTextStyle = TextStyle(
    fontSize: 21.0,
    letterSpacing: 1.5,
    color: Colors.white
  );

  static TextStyle hintTextStyle = TextStyle(
    fontSize: 15,
    letterSpacing: 1.15,
    color: Colors.blue
  );

  static TextStyle ayaTextStyle = TextStyle(
    fontSize: 25,
    letterSpacing: 1.15,
    color: Colors.blue
  );

  List<Widget> _tiles;
  @override
  void initState() {
    super.initState();
    //widget._engine.newGame();
    widget._engine.onCheck.listen(this._postCheck);
    _newGame();    
    //loadSharedPrefAndStartGame();
  }

  void _newGame() {    
    widget._engine.newGame();    
    _tiles = widget._engine.choppedTexts.map((txt) {
      return Chip(
        key: ValueKey(txt),
        label: Text(txt),
        labelStyle: puzzleTextStyle,
        backgroundColor: Colors.blue,
      );
    }).toList();
    print('done preparing tiles');
    _showOriginalText = false;
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        Widget row = _tiles.removeAt(oldIndex);
        _tiles.insert(newIndex, row);
        widget._engine.reorder(oldIndex, newIndex);
      });
    }

    Widget reorWrap = ReorderableWrap(        
        spacing: 8.0,
        runSpacing: 4.0,
        padding: const EdgeInsets.all(8),
        textDirection: TextDirection.rtl,
        children: _tiles,        
        onReorder: _onReorder,
        onNoReorder: (int index) {
          //this callback is optional
          debugPrint(
              '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
        },
        onReorderStarted: (int index) {
          //this callback is optional
          debugPrint(
              '${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
        });

    Widget hint = Padding(
      padding:EdgeInsets.all(8),
      child: Center(      
        child: Text(
          'Tahan dan geser tiap potongan ayat ke tempat yang benar sesuai urutannya',
          style: hintTextStyle,
          textAlign: TextAlign.center,
          ),
        ),
      );
      

    Widget column = new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
          hint,
          reorWrap 
        ],
    );

    
    Widget puzzle = SingleChildScrollView(
      child: column,
    );

    Widget originalText = Padding(
      padding:EdgeInsets.all(8),
      child: Center(      
        child: Text(
          widget._engine.originalText(),
          style: ayaTextStyle,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          ),
        ),
      );

    if (!_showOriginalText) {
      return puzzle;
    } else {
      return originalText;
    }

  }

  void _postCheck(bool correct) {
    if (correct) {
      print('correct');      
      setState(() {
        _showOriginalText = true;
      });      
    }
  }
}

