import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static final String API_KEY = env['RIOT_API_KEY']!;
  static const String baseURL = "na1.api.riotgames.com";//"https://na1.api.riotgames.com/";
  static const String ddragonHost = "ddragon.leagueoflegends.com";
  static const String ddragonURLPatch = "https://ddragon.leagueoflegends.com" + patch;
  static const String ddragonURL = "ddragon.leagueoflegends.com/cdn/";//"http://ddragon.leagueoflegends.com/cdn/";
  static const String rawDDragonAssetsURL = "https://raw.communitydragon.org/latest/game/assets/";//"https://raw.communitydragon.org/latest/game/assets/";
  static const String patch = "/cdn/11.6.1/";
  static const String rawDDragonPluginsURL = "https://raw.communitydragon.org/latest/plugins/";

}