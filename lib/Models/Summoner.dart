import 'package:flutter/material.dart';
import 'package:lolinfo/Networking/DDragonService.dart';

class Summoner {
  late String accountId;
  late int profileIconId;
  late int revisionDate;
  late String name;
  late String id;
  late String puuid;
  late int summonerLevel;
  static Summoner? selected;
  bool isSelected = false;
  late Image profileIcon;
  late Map<String, dynamic> json;

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