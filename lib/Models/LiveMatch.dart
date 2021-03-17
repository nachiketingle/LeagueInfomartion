import 'package:lolinfo/Models/Champion.dart';

import 'LiveMatchParticipant.dart';

class LiveMatch {
  List<LiveMatchParticipant> blueSide = [];
  List<LiveMatchParticipant> redSide = [];
  List<Champion> bannedChamps = [];


  LiveMatch.fromJson(Map<String, dynamic> json) {

    int count = 0;
    for(Map<String, dynamic> summonerJson in json['participants']) {
      if(count < 5) {
        blueSide.add(LiveMatchParticipant.fromJson(summonerJson, true));
      }
      else {
        redSide.add(LiveMatchParticipant.fromJson(summonerJson, false));
      }
      count++;
    }

  }

}