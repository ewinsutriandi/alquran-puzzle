import 'package:flutter/rendering.dart';
import 'package:juz_amma_puzzle/model/quran.dart';
import 'package:juz_amma_puzzle/model/game_stats.dart';
import 'package:juz_amma_puzzle/services/stats_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsApiSharedPrefImpl implements StatsAPI {
  static final String STATS_KEY = 'STATS';
  static final String LAST_SESSION_KEY = 'LAST_SESSION';
  static final String DELIMITER = ';';
  @override
  Future<StatsSura> getSuraStats(Sura s) async {
    List<int> freq = await _readStats();
    int ayaSolved = 0, gamePlayed = 0;
    int minCompletion = freq[s.start];
    int firstUncompleted = -1;
    for (int i = s.start; i < s.start + s.totalAyas; i++) {
      int aFreq = freq[i];
      gamePlayed += aFreq;
      if (aFreq > 0) {
        ayaSolved++;
      } else {
        if (firstUncompleted == -1) {
          firstUncompleted =
              i - s.start + 1; // first aya that is not completed, start at 1
        }
      }
      minCompletion > aFreq ? minCompletion = aFreq : null;
    }
    StatsSura stats = StatsSura(
        gamePlayed: gamePlayed,
        ayaSolved: ayaSolved,
        totalAya: s.totalAyas,
        completionCount: minCompletion,
        firstUncomplete: firstUncompleted);
    return stats;
  }

  @override
  Future<StatsGroup> getStatsGroup(List<Sura> listSura) async {
    List<StatsSura> data = [];
    for (Sura s in listSura) {
      StatsSura d = await getSuraStats(s);
      data.add(d);
    }
    StatsGroup sg = StatsGroup.fromSuraStatsList(data);
    return sg;
  }

  @override
  Future<void> recordCompletion(Sura s, int ayaNumber, bool completed) async {
    debugPrint(
        'Record completion stats to shared pref ${s.name} $ayaNumber $completed');
    List<int> freq = await _readStats();
    int idx = s.start + ayaNumber - 1; // idx of current aya in whole qur'an
    freq[idx] = freq[idx] + 1; // increase completion count by 1
    _saveStats(freq)
        .then((value) => _recordLastSession(s, ayaNumber, completed ? 1 : 0));
  }

  Future<List<int>> _readStats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String raw = prefs.getString(STATS_KEY);
    if (raw == null) {
      debugPrint('data is empty');
      _initializeEmptyStats();
      return _readStats();
    }
    List<String> strFreq = raw.split(DELIMITER);
    List<int> freq = [];
    for (int i = 0; i < strFreq.length; i++) {
      freq.add(int.parse(strFreq[i]));
    }
    return freq;
  }

  Future<void> _saveStats(List<int> freq) async {
    debugPrint('Saving stats');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stats = freq.join(DELIMITER);
    prefs.setString(STATS_KEY, stats);
  }

  void _initializeEmptyStats() {
    debugPrint('Initializing empty stats');
    List<int> emptyFreq = [];
    for (int i = 0; i < 6236; i++) {
      emptyFreq.add(0);
    }
    _saveStats(emptyFreq);
  }

  Future<void> _recordLastSession(
      Sura sura, int ayaNumber, int completed) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LastSession lst = LastSession(sura.idx, ayaNumber, completed);
    String s = lst.toString();
    debugPrint('SHARED PREF - Saving $s');
    prefs.setString(LAST_SESSION_KEY, s);
  }

  @override
  Future<LastSession> lastSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String s = prefs.getString(LAST_SESSION_KEY);
    return LastSession.fromString(s);
  }

  @override
  Future<List<Sura>> suraRecommendation() {
    // TODO: implement suraRecommendation
    throw UnimplementedError();
  }
}
