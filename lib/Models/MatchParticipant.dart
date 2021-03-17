import 'package:lolinfo/Models/Champion.dart';
import 'package:lolinfo/Networking/DDragonService.dart';

class MatchParticipant {

  late int teamId;
  late int spell1Id;
  late int spell2Id;
  late int championId;
  late int profileIconId;
  late String summonerName;
  late String summonerId;
  bool isBlue;
  late Champion champion;

  MatchParticipant(this.teamId, this.spell1Id, this.spell2Id, this.championId, this.profileIconId, this.summonerName, this.summonerId, this.isBlue) {
    champion = Champion.min(id: championId);
  }

  MatchParticipant.fromJson(Map<String, dynamic> json, this.isBlue) {
    teamId = json['teamId'];
    spell1Id = json['spell1Id'];
    spell2Id = json['spell2Id'];
    championId = json['championId'];
    DDragonService.getAllChampions().then((value) {
      champion = value[championId]!;
    });
    //champion = Champion.min(id: championId);
    profileIconId = json['profileIconId'];
    summonerName = json['summonerName'];
    summonerId = json['summonerId'];
  }

}