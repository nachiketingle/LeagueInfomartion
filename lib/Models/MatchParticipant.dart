import 'package:flutter/material.dart';
import 'package:lolinfo/Models/Champion.dart';
import 'package:lolinfo/Networking/DDragonService.dart';

class MatchParticipant {

  int teamId;
  int spell1Id;
  int spell2Id;
  int championId;
  int profileIconId;
  String summonerName;
  String summonerId;
  bool isBlue;
  Champion champion;

  MatchParticipant(this.teamId, this.spell1Id, this.spell2Id, this.championId, this.profileIconId, this.summonerName, this.summonerId, this.isBlue) {
    champion = Champion.min(id: championId);
  }

  MatchParticipant.fromJson(Map<String, dynamic> json, this.isBlue) {
    teamId = json['teamId'];
    spell1Id = json['spell1Id'];
    spell2Id = json['spell2Id'];
    championId = json['championId'];
    DDragonService.getAllChampions().then((value) {
      champion = value[championId];
    });
    //champion = Champion.min(id: championId);
    profileIconId = json['profileIconId'];
    summonerName = json['summonerName'];
    summonerId = json['summonerId'];
  }

}