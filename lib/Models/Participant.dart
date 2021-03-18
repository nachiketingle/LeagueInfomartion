import 'package:lolinfo/Models/ParticipantIdentity.dart';
import 'package:lolinfo/Networking/RiotService.dart';

import 'Champion.dart';

class ParticipantDto {
  late int participantId;
  late int champId;
  late Champion champ;
  late int teamId;
  late bool isBlue;
  late int spell1Id;
  late int spell2Id;
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
    spell2Id = json["spell2Id"];
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

  String get kda => "$kills/$deaths/$assists";

  ParticipantStatsDto.fromJson(Map<String, dynamic> json) {
    kills = json["kills"];
    deaths = json["deaths"];
    assists = json["assists"];
  }
}