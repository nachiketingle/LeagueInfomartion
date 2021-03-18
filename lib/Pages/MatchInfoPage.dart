import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lolinfo/Models/MatchInfo.dart';
import 'package:lolinfo/Models/Participant.dart';
import 'package:lolinfo/Models/ParticipantIdentity.dart';
import 'package:lolinfo/Models/PastMatch.dart';
import 'package:lolinfo/Networking/RiotService.dart';
import 'package:lolinfo/Networking/DDragonService.dart';

class MatchInfoPage extends StatefulWidget {
  MatchInfoPage({Key? key, required this.match}) :
        super(key: key);

  final PastMatch match;

  _MatchInfoState createState() => _MatchInfoState();
}

class _MatchInfoState extends State<MatchInfoPage> {

  PageController _controller = PageController();

  Future<MatchInfo> _getInfo(PastMatch match) async {
    return RiotService.getMatchInfo(match);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.match.gameId.toString())
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _HeroTile(match: widget.match),
            Expanded(
              child: PageView(
                controller: _controller,
                children: [
                  FutureBuilder(
                    future: _getInfo(widget.match),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(),);
                      }

                      MatchInfo info = snapshot.data as MatchInfo;
                      return _AllSummoners(matchInfo: info);
                    },
                  ),
                  Center(
                    child: Text("Second Page"),
                  )
                ],
              ),
            )
          ],
        )
    );
  }

}

class _AllSummoners extends StatelessWidget {
  final MatchInfo matchInfo;
  _AllSummoners({Key? key, required this.matchInfo}) : super(key: key);

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
  List<ParticipantDto> participants;
  bool isBlue;
  bool win;

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

class _HeroTile extends StatelessWidget {
  final PastMatch match;
  _HeroTile({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Hero(
        tag: match.gameId.toString(),
        child: Material(
          type: MaterialType.transparency,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DDragonService.getChampIcon(
                  match.champ.name!,
                  imageWidth: 50
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(match.champ.name!),
                    Text(match.lane, style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12
                    ),),
                  ],
                ),
              ),
              Text(match.dateTime.toLocal().toString())
            ],
          ),
        ),
      ),
    );
  }
}