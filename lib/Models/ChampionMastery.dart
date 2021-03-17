import 'package:lolinfo/Models/Champion.dart';

class ChampionMastery {
  late int championPointTillNextLevel;
  late bool chestGranted;
  late int champId;
  late int lastPlayTime;
  late int champLevel;
  late String summonerId;
  late int champPoints;
  late int champPointsSinceLastLevel;
  late int tokensEarned;

  Champion? champ;

  ChampionMastery.fromJson(Map<String, dynamic> json) {
    
    championPointTillNextLevel = json['championPointsUntilNextLevel'];
    chestGranted = json['chestGranted'];
    champId = json['championId'];
    lastPlayTime = json['lastPlayTime'];
    champLevel = json['championLevel'];
    summonerId = json['summonerId'];
    champPoints = json['championPoints'];
    champPointsSinceLastLevel = json['championPointsSinceLastLevel'];
    tokensEarned = json['tokensEarned'];
  }

  int compareTo(ChampionMastery other) {
    return this.champ!.name!.compareTo(other.champ!.name!);
  }

}