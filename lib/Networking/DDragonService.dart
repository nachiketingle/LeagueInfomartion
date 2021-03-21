import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lolinfo/Helpers/Constants.dart';
import 'package:lolinfo/Models/Champion.dart';
import 'package:lolinfo/Models/SummonerSpell.dart';
import 'package:lolinfo/Networking/Network.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DDragonService {
  static Map<int, Champion> _allChamps = Map(); //champion.json
  static Map<int, SummonerSpell> _allSpells = Map();

  /// Get the profile image based on the id
  static Image getProfileImage(int id) {
    return Image(
      image: CachedNetworkImageProvider(Constants.ddragonURLPatch + "img/profileicon/" + id.toString() + ".png"),
    );
  }

  /// Get the icon for the given champion
  static Image getChampIcon(String name,
      {double? imageWidth, double? imageHeight}) {

    return Image(
      image: CachedNetworkImageProvider(Constants.ddragonURLPatch + "img/champion/" + name + ".png"),
      width: imageWidth,
      height: imageHeight,
    );
  }

  static Image getSpellIcon(SummonerSpell spell,
      {double? imageWidth, double? imageHeight}) {
    return Image(
      image: CachedNetworkImageProvider(Constants.ddragonURLPatch + "img/spell/" + spell.fullImage),
      width: imageWidth,
      height: imageHeight,
    );
  }

  /// Get the appropriate end of game of game image text
  static Image getEndOfGameImage(bool victory,
      {double? imageWidth, double? imageHeight}) {
    return Image(
      image: CachedNetworkImageProvider(
          Constants.rawDDragonAssetsURL + "ux/endofgame/en_us/" +
              (victory ? "victory" : "defeat")  + ".png"
      ),
      width: imageWidth,
      height: imageHeight,
    );
  }

  /// Get the map of all champions
  /// Keys are champion id, and values are the champion objects
  static Future<Map<int, Champion>> getAllChampions() async {
    if (_allChamps.isNotEmpty) {
      return _allChamps;
    }
    print("Pulling all champs from network");
    String type = 'data/en_US/';
    String query = 'champion.json';
    String response = await Network.getDDragon(type, query);
    Map<int, Champion> _finalList = Map();
    Map<String, dynamic> json = jsonDecode(response);
    json = json['data'];
    json.forEach((key, value) {
      Champion currChamp = Champion.fromJson(value);
      _finalList[currChamp.id] = currChamp;
    });
    _allChamps = _finalList;
    return _finalList;
  }

  static Future<Map<int, SummonerSpell>> getAllSummonerSpells() async {
    if(_allSpells.isNotEmpty) {
      return _allSpells;
    }
    print("Pulling all summoner spells from network");
    String type = 'data/en_US/';
    String query = 'summoner.json';
    String response = await Network.getDDragon(type, query);
    Map<int, SummonerSpell> _finalList = Map();
    Map<String, dynamic> json = jsonDecode(response);
    json = json['data'];
    json.forEach((key, value) {
      SummonerSpell spell = SummonerSpell.fromJson(value);
      _finalList[spell.key] = spell;
    });
    _allSpells.addAll(_finalList);
    return _allSpells;
  }

  /// Get the icon with the associated mastery level
  static Image getMasteryIcon(int masteryLevel,
      {double? imageWidth, double? imageHeight}) {
    String val = masteryLevel.toString();
    if (masteryLevel <= 3) {
      val = "default";
    }

    String url = Constants.rawDDragonAssetsURL +
        "ux/mastery/mastery_icon_" + val + ".png";

    return Image(
      image: CachedNetworkImageProvider(url),
      width: imageWidth,
      height: imageHeight,
    );

  }

  /// Get the given champions splash art
  static Image getSplashArt(String name,
      {double? imageWidth, double? imageHeight}) {
    String url = Constants.ddragonURL + "img/champion/splash/" + name + "_0.jpg";
    return Image(
      image: CachedNetworkImageProvider(url),
      width: imageWidth,
      height: imageHeight,
    );
  }

  static Image getGoldIcon({double? imageWidth, double? imageHeight}) {
    return Image(
      image: CachedNetworkImageProvider(Constants.rawDDragonPluginsURL + "rcp-fe-lol-postgame/global/default/mask-icon-gold.png"),
      width: imageWidth,
      height: imageHeight,
    );
  }

  static Image getCSIcon({double? imageWidth, double? imageHeight}) {

    return Image(
      image: CachedNetworkImageProvider(Constants.rawDDragonPluginsURL + "rcp-fe-lol-postgame/global/default/mask-icon-cs.png"),
      width: imageWidth,
      height: imageHeight,
    );
  }
}
