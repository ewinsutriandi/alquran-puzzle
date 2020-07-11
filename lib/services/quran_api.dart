import 'package:juz_amma_puzzle/model/quran.dart';

abstract class QuranAPI {
  Future<List<Sura>> getSuraList();
  
  Future<List<Sura>> getSuraListJuzAmma() async {
    List<Sura> allSura = await getSuraList();
    List<Sura> juzAmma = [];
    for (int i=77; i<allSura.length;i++) {
      juzAmma.add(allSura[i]);
    }
    return juzAmma;
  }

  void lontong() {
    print('lontong');
  }
}