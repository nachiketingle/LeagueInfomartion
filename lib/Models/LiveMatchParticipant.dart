import 'package:lolinfo/Models/Champion.dart';
import 'package:lolinfo/Models/SummonerSpell.dart';
import 'package:lolinfo/Networking/DDragonService.dart';
import 'package:lolinfo/Networking/RiotService.dart';

class LiveMatchParticipant {

  late int teamId;
  late int spell1Id;
  late SummonerSpell spell1;
  late int spell2Id;
  late SummonerSpell spell2;
  late int championId;
  late int profileIconId;
  late String summonerName;
  late String summonerId;
  late bool isBlue;
  late Champion champion;

  LiveMatchParticipant(this.teamId, this.spell1Id, this.spell2Id, this.championId, this.profileIconId, this.summonerName, this.summonerId, this.isBlue) {
    champion = Champion.min(id: championId);
  }

  LiveMatchParticipant.fromJson(Map<String, dynamic> json, this.isBlue) {
    teamId = json['teamId'];
    spell1Id = json['spell1Id'];
    RiotService.getSummonerSpellInfo(spell1Id).then((value) {spell1=value!;});
    spell2Id = json['spell2Id'];
    RiotService.getSummonerSpellInfo(spell2Id).then((value) {spell2=value!;});
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