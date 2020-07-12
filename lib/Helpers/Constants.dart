import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static final String API_KEY = DotEnv().env['RIOT_API_KEY'];
  static final String baseURL = "https://na1.api.riotgames.com/";
  static final String ddragonURL = "http://ddragon.leagueoflegends.com/cdn/10.12.1/";
}