import 'dart:convert';

import 'package:lolinfo/Models/Participant.dart';
import 'package:lolinfo/Models/ParticipantIdentity.dart';

class MatchInfo {
  late int gameId;
  List<ParticipantDto> participants = [];
  List<ParticipantIdentityDto> participantIds = [];
  late TeamStatsDto blueStats;
  late TeamStatsDto redStats;

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

    for(Map<String, dynamic> teamJson in json["teams"]) {
      TeamStatsDto team = TeamStatsDto.fromJson(teamJson);
      if(team.isBlue) blueStats = team;
      else redStats = team;
    }
  }
}

class TeamStatsDto {
  late bool win;

  /// 'Win' if win, otherwise 'Fail'
  void set winString(String string) {
    win = string == 'Win';
  }
  late int teamId;
  late bool isBlue;

  TeamStatsDto.fromJson(Map<String, dynamic> json) {
    teamId = json["teamId"];
    isBlue = teamId == 100;
    winString = json["win"];
  }
}