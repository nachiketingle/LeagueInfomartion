import 'package:lolinfo/Models/Champion.dart';
import 'package:lolinfo/Networking/DDragonService.dart';

class PastMatch {
  late String platformId;
  late int gameId;
  late String role;
  late int season;
  late int champId;
  late Champion champ;
  late int queue;
  late int timestamp;
  late DateTime dateTime;
  late String lane;


  PastMatch.fromJson(Map<String, dynamic> json) {
    platformId = json['platformId'];
    gameId = json['gameId'];
    role = json['role'];
    season = json['season'];
    champId = json['champion'];
    DDragonService.getAllChampions().then((value) {
      champ = value[champId]!;
    });

    queue = json['queue'];
    timestamp = json['timestamp'];
    dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    lane = json['lane'];

  }

}