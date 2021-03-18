class SummonerSpell {
  late String name;
  late int key;
  late String id;
  late String fullImage;

  SummonerSpell.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    key = int.parse(json["key"]);
    fullImage = json["image"]["full"];
  }
}