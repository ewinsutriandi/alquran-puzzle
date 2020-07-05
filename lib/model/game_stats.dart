class StatsSura {  
  int gamePlayed;
  int ayaSolved;
  int totalAya;
  StatsSura({this.gamePlayed,this.ayaSolved,this.totalAya});
  double get progress => ayaSolved / totalAya;
  bool get completed => ayaSolved == totalAya?true:false;     
  String toString() {
    return 'ayaSolved:' + ayaSolved.toString() + ' gamePlayed:' +gamePlayed.toString()
      + ' totalAya'+ totalAya.toString();
  }
}

class StatsGroup {
  int gamePlayed;
  int suraSolved;
  int totalSura;  
  int ayaSolved;
  int totalAya;
  StatsGroup({this.gamePlayed,this.suraSolved,this.totalSura,this.ayaSolved,this.totalAya});
  double get progressSura => suraSolved / totalSura;
  double get progressAya => ayaSolved / totalAya;
  bool get completed => ayaSolved == totalAya?true:false;    
  static StatsGroup fromSuraStatsList(List<StatsSura> statsL) {
    print('I have been called with data count:'+statsL.length.toString());
    int gamePlayed = 0;
    int suraSolved = 0;
    int totalSura = 0;
    int ayaSolved = 0;
    int totalAya = 0;    
    statsL.forEach((stats) {
      print(stats.toString());
      gamePlayed += stats.gamePlayed;      
      totalSura ++;
      stats.completed?suraSolved++:null;
      ayaSolved += stats.ayaSolved;
      totalAya += stats.totalAya;      
    });
    return StatsGroup(ayaSolved: ayaSolved,gamePlayed: gamePlayed,suraSolved: suraSolved, totalAya: totalAya,totalSura: totalSura);
  }

  String toString() {
    return 'ayaSolved:' + ayaSolved.toString() + ' gamePlayed:' +gamePlayed.toString()
      +' suraSolved:'+ suraSolved.toString()+ ' totalAya'+ totalAya.toString()+' totalSura:' +totalSura.toString();
  }
}