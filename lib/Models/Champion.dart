import 'package:flutter/cupertino.dart';
import 'package:lolinfo/Networking/DDragonService.dart';

class Champion {
  int id;
  String name;

  Champion.min({@required this.id});

  Champion.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['key']);
    name = json['id'];
  }

  int compareTo(Champion other) {
    return this.name.compareTo(other.name);
  }

}