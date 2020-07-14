class StatsSura {
  int gamePlayed;
  int ayaSolved;
  int totalAya;
  int completionCount;
  StatsSura(
      {this.gamePlayed, this.ayaSolved, this.totalAya, this.completionCount});
  double get progress => ayaSolved / totalAya;
  bool get completed => ayaSolved == totalAya ? true : false;
  String toString() {
    return 'ayaSolved:' +
        ayaSolved.toString() +
        ' gamePlayed:' +
        gamePlayed.toString() +
        ' totalAya' +
        totalAya.toString();
  }
}

class StatsGroup {
  int gamePlayed;
  int suraSolved;
  int totalSura;
  int ayaSolved;
  int totalAya;
  int completionCount;
  StatsGroup(
      {this.gamePlayed,
      this.suraSolved,
      this.totalSura,
      this.ayaSolved,
      this.totalAya,
      this.completionCount});
  double get progressSura => suraSolved / totalSura;
  double get progressAya => ayaSolved / totalAya;
  bool get completed => ayaSolved == totalAya ? true : false;
  static StatsGroup fromSuraStatsList(List<StatsSura> statsL) {
    print('I have been called with data count:' + statsL.length.toString());
    int gamePlayed = 0;
    int suraSolved = 0;
    int totalSura = 0;
    int ayaSolved = 0;
    int totalAya = 0;
    int minCompletion = statsL[0].completionCount;
    statsL.forEach((stats) {
      //print(stats.toString());
      gamePlayed += stats.gamePlayed;
      totalSura++;
      stats.completed ? suraSolved++ : null;
      ayaSolved += stats.ayaSolved;
      totalAya += stats.totalAya;
      minCompletion > stats.completionCount
          ? minCompletion = stats.completionCount
          : null;
    });
    return StatsGroup(
        ayaSolved: ayaSolved,
        gamePlayed: gamePlayed,
        suraSolved: suraSolved,
        totalAya: totalAya,
        totalSura: totalSura,
        completionCount: minCompletion);
  }

  String toString() {
    return 'ayaSolved:' +
        ayaSolved.toString() +
        ' gamePlayed:' +
        gamePlayed.toString() +
        ' suraSolved:' +
        suraSolved.toString() +
        ' totalAya' +
        totalAya.toString() +
        ' totalSura:' +
        totalSura.toString();
  }
}

class LastSession {
  int suraIdx;
  int ayaNumber;
  int timestamp;
  int completed;

  LastSession(this.suraIdx, this.ayaNumber, this.completed) {
    this.timestamp = new DateTime.now().millisecondsSinceEpoch;
  }

  LastSession.fromstat(
      this.suraIdx, this.ayaNumber, this.timestamp, this.completed);

  String toString() {
    return [
      suraIdx.toString(),
      ayaNumber.toString(),
      timestamp.toString(),
      completed.toString()
    ].join(';');
  }

  static LastSession fromString(String s) {
    print('LAST SESSION from string: $s');
    List<String> vals = s.split(';');
    return LastSession.fromstat(int.parse(vals[0]), int.parse(vals[1]),
        int.parse(vals[2]), int.parse(vals[3]));
  }
}
