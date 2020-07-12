import 'package:flutter/material.dart';
import 'package:lolinfo/Models/Champion.dart';

import 'MatchParticipant.dart';

class LiveMatch {
  List<MatchParticipant> blueSide;
  List<MatchParticipant> redSide;
  List<Champion> bannedChamps;


  LiveMatch.fromJson(Map<String, dynamic> json) {
    blueSide = [];
    redSide = [];
    bannedChamps = [];

    int count = 0;
    for(Map<String, dynamic> summonerJson in json['participants']) {
      if(count < 5) {
        blueSide.add(MatchParticipant.fromJson(summonerJson, true));
      }
      else {
        redSide.add(MatchParticipant.fromJson(summonerJson, false));
      }
      count++;
    }

  }

}