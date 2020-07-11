import 'package:flutter/rendering.dart';
import 'package:juz_amma_puzzle/model/quran.dart';
import 'package:juz_amma_puzzle/model/game_stats.dart';
import 'package:juz_amma_puzzle/services/stats_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsApiSharedPrefImpl extends StatsAPI{
    
  static final String STATS_FILE = 'STATS';
  static final String DELIMITER = ';';
  @override
  Future<StatsSura> getSuraStats(Sura s) async {
    List<int> freq = await _readStats();
    int ayaSolved=0,gamePlayed=0;
    for (int i = s.start;i<s.start+s.totalAyas;i++){
      int aFreq = freq[i];
      gamePlayed+=aFreq;
      if(aFreq>0) {
        ayaSolved++;
      }
    }
    StatsSura stats = StatsSura(gamePlayed: gamePlayed,ayaSolved: ayaSolved,totalAya: s.totalAyas);
    return stats;
  }

  @override
  Future<StatsGroup> getStatsGroup(List<Sura> listSura) async {    
    List<StatsSura> data = [];
    for (Sura s in listSura) {      
      StatsSura d = await getSuraStats(s);      
      data.add(d);
    }        
    StatsGroup sg =  StatsGroup.fromSuraStatsList(data);    
    return sg;                    
  }
  
  @override
  Future<void> recordCompletion(Sura s, int ayaNumber) async {
    debugPrint('Record completion stats to shared pref');
    List<int> freq = await _readStats();
    int cnt = freq[s.start+ayaNumber];
    cnt++;
    freq[s.start+ayaNumber] = cnt;
    _saveStats(freq);
  }

  Future<List<int>> _readStats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String raw = prefs.getString(STATS_FILE);
    if (raw == null) {
      debugPrint('data is empty');
      _initializeEmptyStats();
      return _readStats();
    }
    List<String> strFreq = raw.split(DELIMITER);
    List<int> freq = [];
    for(int i=0;i<strFreq.length;i++) {
      freq.add(int.parse(strFreq[i]));
    }
    return freq;
  }

  void _saveStats(List<int> freq) async {
    debugPrint('Saving stats');
    SharedPreferences prefs = await SharedPreferences.getInstance();    
    String stats = freq.join(DELIMITER);        
    prefs.setString(STATS_FILE, stats);    
  }

  void _initializeEmptyStats() {
    debugPrint('Initializing empty stats');
    List<int> emptyFreq = [];
    for (int i=0;i<6236;i++) {
      emptyFreq.add(0);
    }
    _saveStats(emptyFreq);
  }

}