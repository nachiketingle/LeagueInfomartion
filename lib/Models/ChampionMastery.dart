import 'package:lolinfo/Models/Champion.dart';

class ChampionMastery {
  int championPointTillNextLevel;
  bool chestGranted;
  int champId;
  int lastPlayTime;
  int champLevel;
  String summonerId;
  int champPoints;
  int champPointsSinceLastLevel;
  int tokensEarned;

  Champion champ;

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
    return this.champ.name.compareTo(other.champ.name);
  }

}