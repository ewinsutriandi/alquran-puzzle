import 'package:juz_amma_puzzle/model/quran.dart';

abstract class QuranAPI {
  Future<List<Sura>> getSuraList();
}