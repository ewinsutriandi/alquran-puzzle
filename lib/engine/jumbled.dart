import 'dart:async';
import 'dart:convert';

import 'package:flutter/rendering.dart';

class JumbledTextPuzzle {
  final List<String> _texts;
  JumbledTextPuzzle(this._texts);
  int _minSegment = 2;
  int _maxSegment = 7;
  int _textIdx = -1;
  bool _spaceBetweenChops = false;
  String _originalText;
  List<String> _splittedTexts;
  String originalText() => _originalText;
  StreamController<bool> _onCheck = new StreamController<bool>.broadcast();
  Stream<bool> get onCheck => _onCheck.stream;

  void newGame() {
    if (endOfIdx) {
      // start again from beginning of texts
      _textIdx = -1;
    }
    _textIdx++;
    _originalText = _texts[_textIdx];
    _splitText();
    while (_correctOrder()) {
      _splittedTexts.shuffle();
    }
  }

  void setChoppingRules(int minSegment, int maxSegment, int chrMax) {
    this._minSegment = minSegment;
    this._maxSegment = maxSegment;
  }

  int get currentIdx => _textIdx;
  List<String> get choppedTexts => _splittedTexts;
  bool get endOfIdx => _textIdx == _texts.length - 1;

  bool _correctOrder() {
    String joined = _splittedTexts.join('');
    if (_spaceBetweenChops) {
      joined = _splittedTexts.join(' ');
    }
    debugPrint(joined);
    debugPrint(this._originalText);
    return (joined == _originalText);
  }

  void check() {
    this._onCheck.add(_correctOrder());
  }

  void reorder(int oldIndex, int newIndex) {
    String temp = this._splittedTexts[oldIndex];
    this._splittedTexts.removeAt(oldIndex);
    this._splittedTexts.insert(newIndex, temp);
    check();
  }

  void _splitByLetter() {
    debugPrint('JUMBLED Chop by letter');
    _splittedTexts = _originalText.split('');
    debugPrint('JUMBLED $_splittedTexts');
    _splittedTexts.forEach((element) {
      debugPrint('JUMBLED $element');
      debugPrint('JUMBLED ${utf8.encode(element)}');
    });
  }

  bool _containDiacritics(String text) {
    List<int> diacritics216 = [139, 159];
    List<int> diacritics217 = [139, 160];
    for (int i = 0; i < text.length; i++) {
      List<int> charBytes = utf8.encode(text[i]);
      // check for 216
      if (charBytes[0] == 216 &&
          charBytes[1] >= diacritics216[0] &&
          charBytes[1] <= diacritics216[1]) {
        return true;
      }
      // check for 217
      if (charBytes[0] == 217 &&
          charBytes[1] >= diacritics217[0] &&
          charBytes[1] <= diacritics217[1]) {
        return true;
      }
    }
    return false;
  }

  void _splitByDiacritics() {
    debugPrint('JUMBLED Split text by diacritics');
    List<String> characters = _originalText.split('');
    int charPos = 0;
    _splittedTexts = [];
    String fragment = '';
    while (charPos < characters.length) {
      String curChar = characters[charPos];
      fragment += curChar;
      if (_containDiacritics(curChar)) {
        _splittedTexts.add(fragment);
        debugPrint('JUMBLED FRAG ${utf8.encode(fragment)} $fragment');
        fragment = '';
      }
      charPos++;
    }
    fragment != '' ? _splittedTexts.add(fragment) : null; // last fragment
  }

  void _splitBySpace() {
    debugPrint('JUMBLED Split text by space');
    _splittedTexts = _originalText.split(' ');
  }

  void _splitBySegment() {
    debugPrint('JUMBLED Split text by segment');
    List<String> words = _originalText.split(' ');
    int wordCount = words.length;
    //int wordCountPerSegment = (wordCount / _maxSegment).floor();
    int remainder = wordCount % _maxSegment;
    String segment;
    int wordPos = 0;
    _splittedTexts = [];
    for (int i = 0; i < _maxSegment; i++) {
      segment = words[wordPos];
      wordPos++;
      if (i < remainder) {
        segment += words[wordPos];
        wordPos++;
      }
      _splittedTexts.add(segment);
    }
  }

  void _splitText() {
    _splittedTexts = [];
    List<String> spaceChop = _originalText.split(' ');
    if (spaceChop.length >= _minSegment) {
      _spaceBetweenChops = true;
      if (spaceChop.length <= _maxSegment) {
        _splitBySpace();
      } else {
        _splitBySegment();
      }
    } else {
      _spaceBetweenChops = false;
      if (_containDiacritics(_originalText)) {
        _splitByDiacritics();
      } else {
        _splitByLetter();
      }
    }
  }
}
