import 'dart:convert';

import 'package:lolinfo/Models/Champion.dart';
import 'package:lolinfo/Models/LiveMatch.dart';
import 'package:lolinfo/Models/MatchInfo.dart';
import 'package:lolinfo/Models/PastMatch.dart';
import 'package:lolinfo/Models/Summoner.dart';
import 'package:lolinfo/Models/ChampionMastery.dart';
import 'package:lolinfo/Models/SummonerSpell.dart';
import 'package:lolinfo/Networking/DDragonService.dart';
import 'Network.dart';

class RiotService {

  /// Gets the [Summoner] from the given summoner name
  /// Returns [null] if not found
  static Future<Summoner?> getSummonerInfo(String summonerName) async{
    String type = 'lol/summoner/v4/summoners/by-name/' + summonerName;
    String response = await Network.get(type, Map());
    Map<String, dynamic> json = jsonDecode(response);
    if(json.containsKey('status'))
      return null;

    return Summoner.fromJson(jsonDecode(response));
  }

  /// Gets the [Summoner] from the given puuid
  static Future<Summoner> getSummonerFromPUUID(String puuid) async {
    String type = 'lol/summoner/v4/summoners/by-puuid/' + puuid;
    String response = await Network.get(type, Map());
    return Summoner.fromJson(jsonDecode(response));
  }

  /// Gets the [ChampionMastery] list of all the champions that the summoner has played
  static Future<List<ChampionMastery>> getChampionMasteries(String summonerId) async {
    String type = 'lol/champion-mastery/v4/champion-masteries/by-summoner/' + summonerId;
    String response = await Network.get(type, null);
    List<ChampionMastery> _list = [];
    List<dynamic> json = jsonDecode(response);
    ChampionMastery curr;
    for(Map<String, dynamic> _masteryJson in json) {
      curr = ChampionMastery.fromJson(_masteryJson);
      curr.champ = await getChampionInfo(curr.champId);
      _list.add(curr);
    }

    return _list;
  }

  /// Gets the [Champion] from the champion id
  static Future<Champion?> getChampionInfo(int champId) async {
    Map<int, Champion> _list = await DDragonService.getAllChampions();
    return _list[champId];
  }

  /// Gets the [SummonerSpell] from the summoner spell id
  static Future<SummonerSpell?> getSummonerSpellInfo(int spellId) async {
    Map<int, SummonerSpell> _list = await DDragonService.getAllSummonerSpells();
    return _list[spellId];
  }

  /// Gets the match history of the given user
  /// It is returned as a [List] of [PastMatch]
  /// Length must be less than 100
  static Future<List<PastMatch>> getMatchHistory(String accountId, {String length: '20'}) async {
    assert(int.tryParse(length) != null);
    assert(int.tryParse(length)! <= 100);
    String type = 'lol/match/v4/matchlists/by-account/' + accountId;
    Map<String, String> queries = Map();
    queries['endIndex'] = length;
    String response = await Network.get(type, queries);
    List<PastMatch> _list = [];
    Map<String, dynamic> json = jsonDecode(response);
    List<dynamic> _matchList = json['matches'];

    for(Map<String, dynamic> _matchJson in _matchList) {
      _list.add(PastMatch.fromJson(_matchJson));
    }

    return _list;
  }

  /// Gets the entire [MatchInfo] based on the [PastMatch]
  static Future<MatchInfo> getMatchInfo(PastMatch pastMatch) async {
    String type = 'lol/match/v4/matches/' + pastMatch.gameId.toString();
    String response = await Network.get(type, null);
    Map<String, dynamic> json = jsonDecode(response);
    return MatchInfo.fromJson(json);
  }

  /// Gets the [LiveMatch] of the given summoner id
  /// If there is no [LiveMatch], [null] is returned
  static Future<LiveMatch?> getLiveMatch(String summonerId) async {
    String type = 'lol/spectator/v4/active-games/by-summoner/' + summonerId;
    String response = await Network.get(type, null);
    Map<String, dynamic> json = jsonDecode(response);
    if(!json.containsKey('participants')) {
      return null;
    }
    return LiveMatch.fromJson(json);

  }



}