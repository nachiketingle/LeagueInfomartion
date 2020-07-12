import 'dart:convert';

import 'package:lolinfo/Models/Champion.dart';
import 'package:lolinfo/Models/LiveMatch.dart';
import 'package:lolinfo/Models/PastMatch.dart';
import 'package:lolinfo/Models/Summoner.dart';
import 'package:lolinfo/Models/ChampionMastery.dart';
import 'package:lolinfo/Networking/DDragonService.dart';
import 'Network.dart';

class RiotService {



  static Future<Summoner> getSummonerInfo(String summonerName) async{
    String type = 'lol/summoner/v4/summoners/by-name/' + summonerName;
    String response = await Network.get(type, null);
    Map<String, dynamic> json = jsonDecode(response);
    if(json.containsKey('status'))
      return null;

    return Summoner.fromJson(jsonDecode(response));
  }

  static Future<Summoner> getSummonerFromPUUID(String puuid) async {
    String type = 'lol/summoner/v4/summoners/by-puuid/' + puuid;
    String response = await Network.get(type, null);
    return Summoner.fromJson(jsonDecode(response));
  }

  static Future<List<ChampionMastery>> getChampionMasteries(String summonerId) async {
    // TODO: Return all ChampionMastery for chosen summoner
    String type = 'lol/champion-mastery/v4/champion-masteries/by-summoner/' + summonerId;
    String response = await Network.get(type, null);
    List<ChampionMastery> _list = List();
    List<dynamic> json = jsonDecode(response);
    ChampionMastery curr;
    for(Map<String, dynamic> _masteryJson in json) {
      curr = ChampionMastery.fromJson(_masteryJson);
      curr.champ = await getChampionInfo(curr.champId);
      _list.add(curr);
    }

    return _list;
  }

  static Future<Champion> getChampionInfo(int champId) async {
    Map<int, Champion> _list = await DDragonService.getAllChampions();
    return _list[champId];
  }

  static Future<List<PastMatch>> getMatchHistory(String accountId) async {
    String type = 'lol/match/v4/matchlists/by-account/' + accountId;
    Map<String, String> queries = Map();
    queries['endIndex'] = '20';
    String response = await Network.get(type, queries);
    List<PastMatch> _list = List();
    Map<String, dynamic> json = jsonDecode(response);
    List<dynamic> _matchList = json['matches'];

    for(Map<String, dynamic> _matchJson in _matchList) {
      _list.add(PastMatch.fromJson(_matchJson));
    }

    return _list;
  }

  static Future<LiveMatch> getLiveMatch(String summonerId) async {
    String type = 'lol/spectator/v4/active-games/by-summoner/' + summonerId;
    String response = await Network.get(type, null);
    Map<String, dynamic> json = jsonDecode(response);
    if(!json.containsKey('participants')) {
      return null;
    }
    return LiveMatch.fromJson(json);

  }

}