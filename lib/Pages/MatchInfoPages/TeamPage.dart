import 'package:flutter/material.dart';
import 'package:lolinfo/Models/Participant.dart';
import 'package:lolinfo/Models/MatchInfo.dart';
import 'package:lolinfo/Networking/DDragonService.dart';

class TeamInfoPage extends StatelessWidget {
  TeamInfoPage({Key? key, required this.team, required this.stats, required this.isBlue}) : super(key: key);
  final List<ParticipantDto> team;
  final TeamStatsDto stats;
  final bool isBlue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text(isBlue ? "Blue Side" : "Red Side")),
          for(ParticipantDto participant in team) ...{
            _ParticipantTile(participant: participant,)
          }
        ],
      ),
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  _ParticipantTile({Key? key, required this.participant}) : super(key: key);
  final ParticipantDto participant;

  @override
  Widget build(BuildContext context) {
    ParticipantIdentityDto identity = participant.identityDto;
    ParticipantStatsDto stats = participant.statsDto;
    PlayerDto player = identity.player;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(player.summonerName),
        SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                DDragonService.getChampIcon(participant.champ.name!, imageHeight: 50),
                SizedBox(width: 5,),
                Column(
                  children: [
                    DDragonService.getSpellIcon(participant.spell1, imageHeight: 22),
                    SizedBox(height: 5,),
                    DDragonService.getSpellIcon(participant.spell2, imageHeight: 22),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stats.kda),
                Row(
                  children: [
                    DDragonService.getGoldIcon(imageHeight: 15),
                    Text(stats.gold.toString()),
                  ],
                ),
                Row(
                  children: [
                    DDragonService.getCSIcon(imageHeight: 15),
                    Text(stats.cs.toString()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );

  }
}