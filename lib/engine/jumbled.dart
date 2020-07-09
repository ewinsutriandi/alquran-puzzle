import 'dart:async';

import 'package:flutter/rendering.dart';

class JumbledTextPuzzle {
	final List<String> _texts;
	JumbledTextPuzzle(this._texts);	
	int _minSegment = 2;
	int _maxSegment = 9;
	int _chrMaxPerSegment = 37;
	int _textIdx = -1;
  bool _spaceBetweenChops = false;
	String _originalText;
	List<String> _choppedTexts;
  String originalText () => _originalText;
  StreamController<bool> _onCheck = new StreamController<bool>.broadcast();
  Stream<bool> get onCheck => _onCheck.stream;

	void newGame() {
    _textIdx++;
		_originalText = _texts[_textIdx];
		_chopText();
		_choppedTexts.shuffle();
	}

	void setChoppingRules(int minSegment,int maxSegment,int chrMax) {
		this._minSegment = minSegment;
		this._maxSegment = maxSegment;
		this._chrMaxPerSegment = chrMax;
	}

  List<String> get choppedTexts => _choppedTexts;

	void check() {
		String joined = _choppedTexts.join(''); 
    if (_spaceBetweenChops) {
      joined = _choppedTexts.join(' ');		
    }     
    this._onCheck.add(joined == _originalText);    
    debugPrint(joined);
    debugPrint(this._originalText);
	}

  void reorder(int oldIndex,int newIndex) {
    String temp = this._choppedTexts[oldIndex];
    this._choppedTexts.removeAt(oldIndex);
    this._choppedTexts.insert(newIndex, temp);    
    check();
  }

	void _chopText() {
		_choppedTexts = [];
		List<String> spaceChop = _originalText.split(' ');
		if (spaceChop.length < _minSegment) { 
			// too few parts, split by letters			
      _choppedTexts = _originalText.split('');
      _spaceBetweenChops = false;
		} else if (spaceChop.length <= this._minSegment) { 
			// segments less than minimum, return text splitted by space
			print('chopped by space');
      _choppedTexts = spaceChop;
      _spaceBetweenChops = true;
		} else {
			// create segment between min and max segment count
      print('chopped by segment');
			int segmentCount = _minSegment;
			int chrPerMaxSegmentRatio = (_originalText.length / this._maxSegment).round();
      print(chrPerMaxSegmentRatio.toString()+' : '+_chrMaxPerSegment.toString());
			if (chrPerMaxSegmentRatio >= _chrMaxPerSegment) {
				segmentCount = _maxSegment;
			} else {
				segmentCount = (_minSegment + (chrPerMaxSegmentRatio/_chrMaxPerSegment * (_maxSegment -_minSegment))).floor();
			}
      print(chrPerMaxSegmentRatio.toString()+' : '+_chrMaxPerSegment.toString()+' : '+segmentCount.toString());      
			int wps = (spaceChop.length / segmentCount).floor(); // word per segment

			int remainder = spaceChop.length % segmentCount; // to be distributed as extra word
			int pos = 0;
			for (int s=0; s < segmentCount; s++) {
				String phrase = '';
				for (int w=0; w<wps; w++) {
					if (phrase.isNotEmpty) {
						phrase += ' ';
					}
					phrase += spaceChop[pos];            
					pos++;
				}
				if (s < remainder) { // extra word
					phrase += ' '+spaceChop[pos];
					pos++;
				}
        print(phrase);
				_choppedTexts.add(phrase);
        _spaceBetweenChops = true;
			}
		}
		
	}

}