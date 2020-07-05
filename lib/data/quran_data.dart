import 'package:get_it/get_it.dart';
import 'package:juz_amma_puzzle/model/quran.dart';
import 'package:juz_amma_puzzle/services/quran_api.dart';

class QuranData {
  Future<List<Sura>> _suraList;
  final sl = GetIt.instance;

  QuranData() {
    _loadData();
  }

  Future<List<Sura>> get suraList => _suraList;

  void _loadData() async {
    _suraList = sl.get<QuranAPI>().getSuraList();
  }
  
}