import 'package:flutter/material.dart';
import 'package:lolinfo/Models/MatchInfo.dart';
import 'package:lolinfo/Models/Participant.dart';
import 'package:lolinfo/Networking/DDragonService.dart';

class AllSummoners extends StatelessWidget {
  final MatchInfo matchInfo;
  AllSummoners({Key? key, required this.matchInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ParticipantDto> participants = matchInfo.participants;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _SummonerSide(participants: participants, isBlue: true, win: matchInfo.blueStats.win,),
        _SummonerSide(participants: participants, isBlue: false, win: matchInfo.redStats.win,),

      ],
    );

  }
}

class _SummonerSide extends StatelessWidget {
  final List<ParticipantDto> participants;
  final bool isBlue;
  final bool win;

  _SummonerSide({Key? key, required this.participants, required this.isBlue, required this.win})
      :super(key: key);

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DDragonService.getEndOfGameImage(win, imageHeight: 75),
          Expanded(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: participants.length ~/ 2,
              itemBuilder: (context, index) {
                // Get the correct participant
                index += isBlue ? 0 : participants.length ~/ 2;
                ParticipantDto participant = participants[index];

                // Get participant information
                ParticipantIdentityDto participantId = participant.identityDto;
                PlayerDto player = participantId.player;
                ParticipantStatsDto stats = participant.statsDto;
                ParticipantTimelineDto timeline = participant.timelineDto;

                // Display of widgets
                List<Widget> order = [
                  DDragonService.getChampIcon(
                    participant.champ.name!,
                    imageHeight: 50,
                  ),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: isBlue ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                    children: [
                      Text(
                        player.summonerName,
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "${timeline.lane}",
                        style: TextStyle(fontSize: 10),
                      ),
                      Text(
                        "${stats.kda}",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ];

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: isBlue ? MainAxisAlignment.start : MainAxisAlignment.end,
                    children: [
                      // Change layout order based on team color
                      if(isBlue) ...order
                      else ...order.reversed
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}