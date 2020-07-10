import 'package:get_it/get_it.dart';
import 'package:juz_amma_puzzle/data/quran_data.dart';
import 'package:juz_amma_puzzle/services/quran_api.dart';
import 'package:juz_amma_puzzle/services/quran_api_xml_impl.dart';
import 'package:juz_amma_puzzle/services/stats_api.dart';
import 'package:juz_amma_puzzle/services/stats_api_shared_pref.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {  
  serviceLocator.registerLazySingleton<QuranAPI>(() => QuranApiXmlImplementation());
  serviceLocator.registerLazySingleton<QuranData>(()=> QuranData());
  serviceLocator.registerLazySingleton<StatsAPI>(() => StatsApiSharedPrefImpl());
}