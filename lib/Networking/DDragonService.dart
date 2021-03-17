import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lolinfo/Helpers/Constants.dart';
import 'package:lolinfo/Models/Champion.dart';
import 'package:lolinfo/Networking/Network.dart';

class DDragonService {
  static Map<int, Champion> _allChamps = Map(); //champion.json
  static Map<String, Widget> _assets = Map();

  static Image getProfileImage(int id) {
    return Image.network(
      Constants.ddragonURLPatch + "img/profileicon/" + id.toString() + ".png",
    );
  }

  static Image getChampIcon(String name,
      {double? imageWidth, double? imageHeight}) {
    return Image.network(
      Constants.ddragonURLPatch + "img/champion/" + name + ".png",
      width: imageWidth,
      height: imageHeight,
    );
  }

  static Future<Map<int, Champion>> getAllChampions() async {
    if (_allChamps.isNotEmpty) {
      return _allChamps;
    }
    print("Pulling All champs from network");
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

  static Image getMasteryIcon(int masteryLevel,
      {double? imageWidth, double? imageHeight}) {
    String val = masteryLevel.toString();
    if (masteryLevel <= 3) {
      val = "default";
    }

    Image image;
    String url = Constants.rawDDragonAssetsURL +
        "ux/mastery/mastery_icon_" +
        val +
        ".png";

    if (imageWidth == null && imageHeight == null) {
      if (_assets.containsKey(url)) {
        image = _assets[url] as Image;
      } else {
        image = Image.network(url);
        _assets[url] = image;
      }
    } else {
      image = Image.network(
        url,
        width: imageWidth,
        height: imageHeight,
      );
    }
    return image;
  }

  static Image getSplashArt(String name,
      {double? imageWidth, double? imageHeight}) {
        Image image;
        String url = Constants.ddragonURL + "img/champion/splash/" + name + "_0.jpg";

    if (imageWidth == null && imageHeight == null) {
      if (_assets.containsKey(url)) {
        image = _assets[url] as Image;
      } else {
        image = Image.network(url);
        _assets[url] = image;
      }
    } else {
      image = Image.network(
        url,
        width: imageWidth,
        height: imageHeight,
      );
    }
    return image;
  }
}
