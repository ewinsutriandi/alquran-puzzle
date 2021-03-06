import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:juz_amma_puzzle/model/quran.dart';
import 'package:juz_amma_puzzle/services/quran_api.dart';
import 'package:xml/xml.dart';

class QuranApiXmlImplementation extends QuranAPI {
  Future<String> _loadAsset(String path) async {
    print('load string from: ' + path);
    String str = await rootBundle.loadString(path);
    return str;
  }

  Future<List<Sura>> getSuraList() async {
    List<Sura> suraList = await _suraListFromTanzilXML()
        .then((value) => _loadMetaID(value))
        .then((value) => _loadContent(value))
        .then((value) => _loadTranslationKemenag(value));
    return suraList;
  }

  Future<List<Sura>> _suraListFromTanzilXML() async {
    List<Sura> suraList;
    String path = 'assets/tanzil/quran-data.xml';
    String str = await _loadAsset(path);
    suraList = [];
    XmlDocument metaDoc = parse(str);
    Iterable<XmlElement> suras = metaDoc.findAllElements('sura');
    print('chel: ' + suras.length.toString());
    suras.forEach((el) {
      Sura s = Sura();
      s.idx = int.parse(el.getAttribute('index'));
      s.totalAyas = int.parse(el.getAttribute('ayas'));
      s.start = int.parse(el.getAttribute('start'));
      s.name = el.getAttribute('name');
      s.tEnglish = el.getAttribute('tname');
      s.trEnglish = el.getAttribute('ename');
      s.type = el.getAttribute('type');
      suraList.add(s);
    });
    print('done loading main meta');
    return suraList;
  }

  Future<List<Sura>> _loadMetaID(List<Sura> suraList) async {
    String path = 'assets/quran-meta-id.json';
    String raw = await _loadAsset(path);
    var obj = jsonDecode(raw);
    List<dynamic> arr = obj['alquran'];
    for (int i = 0; i < suraList.length; i++) {
      Sura s = suraList[i];
      s.tIndonesia = arr[i]['nama'];
      s.trIndonesia = arr[i]['arti_nama'];
      s.typeIndonesia = arr[i]['tempat_turun'];
    }
    print('done loading meta ID');
    return suraList;
  }

  Future<List<Sura>> _loadContent(List<Sura> suraList) async {
    List<String> suraContent;
    String path = 'assets/tanzil/quran-simple.txt';
    String raw = await _loadAsset(path);
    suraContent = LineSplitter().convert(raw);
    for (int i = 0; i < suraList.length; i++) {
      Sura s = suraList[i];
      s.contents = [];
      for (int a = s.start; a < s.start + s.totalAyas; a++) {
        String aya = suraContent[a];
        if (i > 0 && a == s.start) {
          // remove bismillah except for al fatiha
          aya = aya.substring(38, aya.length);
        }
        s.contents.add(aya);
      }
    }
    print('done loading content');
    return suraList;
  }

  Future<List<Sura>> _loadTranslationKemenag(List<Sura> suraList) async {
    List<String> suraContent;
    String path = 'assets/tanzil/id.indonesian.txt';
    String raw = await _loadAsset(path);
    suraContent = LineSplitter().convert(raw);
    for (int i = 0; i < suraList.length; i++) {
      Sura s = suraList[i];
      s.contentsTrans = [];
      for (int a = s.start; a < s.start + s.totalAyas; a++) {
        s.contentsTrans.add(suraContent[a]);
      }
    }
    print('done loading translation');
    return suraList;
  }
}
