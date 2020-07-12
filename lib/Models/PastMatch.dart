import 'package:lolinfo/Models/Champion.dart';
import 'package:lolinfo/Networking/DDragonService.dart';

class PastMatch {
  String platformId;
  int gameId;
  String role;
  int season;
  int champId;
  Champion champ;
  int queue;
  int timestamp;
  DateTime dateTime;
  String lane;


  PastMatch.fromJson(Map<String, dynamic> json) {
    platformId = json['platformId'];
    gameId = json['gameId'];
    role = json['role'];
    season = json['season'];
    champId = json['champion'];
    DDragonService.getAllChampions().then((value) {
      champ = value[champId];
    });

    queue = json['queue'];
    timestamp = json['timestamp'];
    dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    lane = json['lane'];

  }

}