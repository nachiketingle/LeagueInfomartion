import 'package:lolinfo/Models/ParticipantIdentity.dart';
import 'package:lolinfo/Models/SummonerSpell.dart';
import 'package:lolinfo/Networking/RiotService.dart';
export 'ParticipantIdentity.dart';

import 'Champion.dart';

class ParticipantDto {
  late int participantId;
  late int champId;
  late Champion champ;
  late int teamId;
  late bool isBlue;
  late int spell1Id;
  late SummonerSpell spell1;
  late int spell2Id;
  late SummonerSpell spell2;
  ParticipantIdentityDto identityDto;
  late ParticipantTimelineDto timelineDto;
  late ParticipantStatsDto statsDto;

  ParticipantDto.fromJson(Map<String, dynamic> json, this.identityDto) {
    participantId = json["participantId"];
    champId = json["championId"];
    RiotService.getChampionInfo(champId).then((value) {champ=value!;});
    teamId = json["teamId"];
    isBlue = teamId == 100;
    spell1Id = json["spell1Id"];
    RiotService.getSummonerSpellInfo(spell1Id).then((value) {spell1=value!;});
    spell2Id = json["spell2Id"];
    RiotService.getSummonerSpellInfo(spell2Id).then((value) {spell2=value!;});
    timelineDto = ParticipantTimelineDto.fromJson(json["timeline"]);
    statsDto = ParticipantStatsDto.fromJson(json["stats"]);
  }

}

class ParticipantTimelineDto {
  late String lane;
  late String role;

  ParticipantTimelineDto.fromJson(Map<String, dynamic> json) {
    lane = json["lane"];
    role = json["role"];
  }
}

class ParticipantStatsDto {
  late int kills;
  late int deaths;
  late int assists;
  late int gold;
  late int cs;

  String get kda => "$kills/$deaths/$assists";

  ParticipantStatsDto.fromJson(Map<String, dynamic> json) {
    kills = json["kills"];
    deaths = json["deaths"];
    assists = json["assists"];
    gold = json["goldEarned"];
    cs = json["totalMinionsKilled"] + json["neutralMinionsKilled"];
  }
}