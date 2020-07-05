import 'dart:math';

import 'package:juz_amma_puzzle/model/game_stats.dart';
import 'package:juz_amma_puzzle/model/quran.dart';
import 'package:juz_amma_puzzle/services/stats_api.dart';

class StatsAPIMockImpl implements StatsAPI {
  Future<StatsSura> getSuraStats(Sura s){
    int totalAya = s.totalAyas;
    int rnd = new Random().nextInt(5);
    int ayaSolved;
    if (rnd == 4) {
      ayaSolved = totalAya;
    } else {
      ayaSolved = (1 + (new Random()).nextInt(totalAya-1));      
    }
    int gamePlayed = (ayaSolved + (new Random()).nextInt(3*ayaSolved));
    return Future.delayed(
      Duration(milliseconds: 1),
      () {        
        return StatsSura(gamePlayed: gamePlayed,ayaSolved:ayaSolved,totalAya: totalAya );
      }
    );
  }
  Future<StatsGroup> getStatsGroup(List<Sura> listSura) async {
    print('Get mock stats group for sura size of: '+listSura.length.toString());      
    List<StatsSura> data = [];
    for (Sura s in listSura) {      
      StatsSura d = await getSuraStats(s);      
      data.add(d);
    }        
    StatsGroup sg =  StatsGroup.fromSuraStatsList(data);
    print(sg.toString());
    return sg;                    
  }
}