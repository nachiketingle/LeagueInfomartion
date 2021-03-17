import 'dart:convert';

import 'package:lolinfo/Models/Participant.dart';
import 'package:lolinfo/Models/ParticipantIdentity.dart';

class MatchInfo {
  late int gameId;
  List<ParticipantDto> participants = [];
  List<ParticipantIdentityDto> participantIds = [];

  MatchInfo.fromJson(Map<String, dynamic> json) {
    gameId = json["gameId"];
    List<dynamic> ids = json["participantIdentities"];
    for(Map<String, dynamic> idJson in ids) {
      participantIds.add(ParticipantIdentityDto.fromJson(idJson));
    }

    int count = 0;
    for(Map<String, dynamic> participantJson in json["participants"]) {
      ParticipantDto participant = ParticipantDto.fromJson(participantJson, participantIds[count++]);
      participants.add(participant);
    }
  }
}