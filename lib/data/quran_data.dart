import 'package:get_it/get_it.dart';
import 'package:juz_amma_puzzle/model/quran.dart';
import 'package:juz_amma_puzzle/services/quran_api.dart';

class QuranData {
  static final QuranData _singleton = QuranData._internal();
  Future<List<Sura>> _suraList;
  final sl = GetIt.instance;
  final juz30Start = 78; // an naba
  factory QuranData() {
    return _singleton;
  }

  QuranData._internal() {
    _loadData();
  }

  Future<List<Sura>> get suraList => _suraList;

  Future<List<Sura>> get suraListJuzAmma async {
    List<Sura> suraList = await _suraList;
    List<Sura> juzAmma = [];
    for (int i = juz30Start; i <= 114; i++) {
      Sura s = suraList[i - 1];
      juzAmma.add(s);
    }
    List<Sura> reversed = new List.from(juzAmma.reversed);
    return reversed;
  }

  void _loadData() async {
    _suraList = sl.get<QuranAPI>().getSuraList();
  }

  Future<Sura> getByIndex(int idx) async {
    List<Sura> suraList = await _suraList;
    return suraList[idx - 1];
  }
}
