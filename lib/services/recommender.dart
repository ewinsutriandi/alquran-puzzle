import 'dart:async';
import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:juz_amma_puzzle/data/quran_data.dart';
import 'package:juz_amma_puzzle/model/game_stats.dart';
import 'package:juz_amma_puzzle/model/quran.dart';
import 'package:juz_amma_puzzle/services/stats_api.dart';

class Recommender {
  static Future<List<Sura>> getRecommendation(int size) async {
    List<Sura> recs = [];
    // get sura in which some ayas is solved
    Sura unfinished = await _getPartiallyFinishedSura();
    if (unfinished != null) {
      debugPrint('Recommender: unfinished ${unfinished.tIndonesia}');
      recs.add(unfinished);
    }
    // get sura from juz amma that has no solved aya
    Sura unopened = await _getUnopenedSuraJuzAmma();
    if (unopened != null) {
      debugPrint('Recommender: unopened ${unopened.tIndonesia}');
      recs.add(unopened);
    }
    // get sura from juz amma that has no solved aya
    Sura shortest = await _getUnopenedShortestSura();
    if (shortest != null) {
      debugPrint('Recommender: shortest ${shortest.tIndonesia}');
      recs.add(shortest);
    }
    // check length of reccomendation, add random sura if < expected size
    while (recs.length < size) {
      Sura random = await _getRandomSura();
      debugPrint('Recommender: random ${random.tIndonesia}');
      recs.add(random);
    }
    return recs;
  }

  static Future<Sura> _getPartiallyFinishedSura() async {
    //GetIt.I<StatsGroup>().
    List<Sura> suraList = GetIt.I<QuranData>().suraList;
    List<Sura> unfinished = [];
    for (int i = 0; i < suraList.length; i++) {
      Sura s = suraList[i];
      StatsSura stats = await GetIt.I<StatsAPI>().getSuraStats(s);
      if (!stats.completed && stats.ayaSolved > 0) {
        unfinished.add(s);
      }
    }
    if (unfinished.length == 0) {
      return null;
    }
    return unfinished[new Random().nextInt(unfinished.length)];
  }

  static Future<Sura> _getUnopenedSuraJuzAmma() async {
    List<Sura> suraList = GetIt.I<QuranData>().suraListJuzAmma;
    for (int i = 0; i < suraList.length; i++) {
      Sura s = suraList[i];
      StatsSura stats = await GetIt.I<StatsAPI>().getSuraStats(s);
      if (stats.ayaSolved == 0) {
        return s;
      }
    }
    return null;
  }

  static Future<Sura> _getUnopenedShortestSura() async {
    List<Sura> suraList = GetIt.I<QuranData>().suraList;
    List<Sura> shorts = [];
    for (int i = 0; i < suraList.length; i++) {
      Sura s = suraList[i];
      StatsSura stats = await GetIt.I<StatsAPI>().getSuraStats(s);
      if (!stats.completed) {
        shorts.add(s);
      }
    }
    if (shorts.length == 0) {
      return null;
    } else {
      shorts.sort((a, b) => a.totalAyas.compareTo(b.totalAyas));
    }
    return shorts[0];
  }

  static Future<Sura> _getRandomSura() async {
    List<Sura> suraList = GetIt.I<QuranData>().suraList;
    return suraList[new Random().nextInt(suraList.length)];
  }
}
