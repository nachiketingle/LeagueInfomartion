import 'dart:convert';

class ParticipantIdentityDto {
  late int participantId;
  late PlayerDto player;

  ParticipantIdentityDto.fromJson(Map<String, dynamic> json) {
    participantId = json["participantId"];
    Map<String, dynamic> playerJson = json["player"];
    player = PlayerDto.fromJson(playerJson);
  }

}

class PlayerDto {
  late String summonerName;
  late String summonerId;
  late int profileIconId;

  PlayerDto.fromJson(Map<String, dynamic> json) {
    summonerName = json["summonerName"];
    summonerId = json["summonerId"];
    profileIconId = json["profileIcon"];
  }
}