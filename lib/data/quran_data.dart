import 'package:get_it/get_it.dart';
import 'package:juz_amma_puzzle/model/quran.dart';
import 'package:juz_amma_puzzle/services/quran_api.dart';

class QuranData {
  Future<bool> onReady;
  List<Sura> _suraList;
  static final juz30Start = 78; // an naba
  List<Sura> get suraList => _suraList;

  QuranData() {
    onReady = new Future(() {
      return _loadData();
    });
  }

  List<Sura> get suraListJuzAmma {
    List<Sura> juzAmma = [];
    for (int i = juz30Start; i <= 114; i++) {
      Sura s = _suraList[i - 1];
      juzAmma.add(s);
    }
    List<Sura> reversed = new List.from(juzAmma.reversed);
    return reversed;
  }

  Future<bool> _loadData() async {
    print('QURAN DATA: load sura list');
    _suraList = await GetIt.I<QuranAPI>().getSuraList();
    return true;
  }

  Sura getByIndex(int idx) {
    return _suraList[idx - 1];
  }
}
