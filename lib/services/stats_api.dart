import 'package:juz_amma_puzzle/model/game_stats.dart';
import 'package:juz_amma_puzzle/model/quran.dart';

abstract class StatsAPI {
  Future<StatsSura> getSuraStats(Sura s);
  Future<StatsGroup> getStatsGroup(List<Sura> listSura);
}