import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lolinfo/Models/MatchInfo.dart';
import 'package:lolinfo/Models/LiveMatchParticipant.dart';
import 'package:lolinfo/Models/Participant.dart';
import 'package:lolinfo/Models/ParticipantIdentity.dart';
import 'package:lolinfo/Models/PastMatch.dart';
import 'package:lolinfo/Networking/RiotService.dart';
import '../Networking/DDragonService.dart';

class MatchInfoPage extends StatefulWidget {
  MatchInfoPage({Key? key, required this.match}) :
        super(key: key);

  final PastMatch match;

  _MatchInfoState createState() => _MatchInfoState();
}

class _MatchInfoState extends State<MatchInfoPage> {

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
            FutureBuilder(
              future: _getInfo(widget.match),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(),);
                }

                MatchInfo info = snapshot.data as MatchInfo;
                return Expanded(child: _AllSummoners(matchInfo: info));
              },
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

    return ListView.builder(
      itemCount: participants.length,
      itemBuilder: (context, index) {
        ParticipantDto participant = participants[index];
        ParticipantIdentityDto participantId = participant.identityDto;
        PlayerDto player = participantId.player;
        return Text(player.summonerName + "\t"+ participant.participantId.toString());
      },
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