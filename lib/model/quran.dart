class Sura {
  int idx;
  String name;
  int totalAyas;
  int start;
  String type;
  String typeIndonesia;
  String tEnglish;
  String trEnglish;
  String tIndonesia;
  String trIndonesia;
  List<String> contents;
  String toString() {
    return name+' '+tEnglish+' '+trEnglish;
  }
}
