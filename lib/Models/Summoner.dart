import 'package:flutter/material.dart';
import 'package:lolinfo/Networking/DDragonService.dart';

class Summoner {
  String accountId;
  int profileIconId;
  int revisionDate;
  String name;
  String id;
  String puuid;
  int summonerLevel;
  static Summoner selected;
  bool isSelected;
  Image profileIcon;
  Map<String, dynamic> json;

  Summoner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accountId = json['accountId'];
    puuid = json['puuid'];
    name = json['name'];
    profileIconId = json['profileIconId'];
    revisionDate = json['revisionDate'];
    summonerLevel = json['summonerLevel'];
    profileIcon = DDragonService.getProfileImage(profileIconId);
    this.json = json;
  }

}