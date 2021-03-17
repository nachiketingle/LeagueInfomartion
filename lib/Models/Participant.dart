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

  ParticipantDto.fromJson(Map<String, dynamic> json, this.identityDto) {
    participantId = json["participantId"];
    champId = json["championId"];
    RiotService.getChampionInfo(champId).then((value) {champ=value!;});
    teamId = json["teamId"];
    isBlue = teamId == 100;
    spell1Id = json["spell1Id"];
    spell2Id = json["spell2Id"];
  }

}