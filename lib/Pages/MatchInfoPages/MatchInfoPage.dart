import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lolinfo/Models/MatchInfo.dart';
import 'package:lolinfo/Models/Participant.dart';
import 'package:lolinfo/Models/PastMatch.dart';
import 'package:lolinfo/Networking/RiotService.dart';
import 'package:lolinfo/Networking/DDragonService.dart';
import 'package:lolinfo/Pages/MatchInfoPages/TeamPage.dart';

import 'AllSummonersPage.dart';

class MatchInfoPage extends StatefulWidget {
  MatchInfoPage({Key? key, required this.match}) :
        super(key: key);

  final PastMatch match;

  _MatchInfoState createState() => _MatchInfoState();
}

class _MatchInfoState extends State<MatchInfoPage> {

  PageController _controller = PageController(initialPage: 1);

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
              child: FutureBuilder(
                future: _getInfo(widget.match),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(),);
                  }

                  // Get the needed information from the future
                  MatchInfo info = snapshot.data as MatchInfo;
                  List<ParticipantDto> blueTeam = info.participants
                      .getRange(0, 5).toList(growable: false);
                  List<ParticipantDto> redTeam = info.participants
                      .getRange(5, 10).toList(growable: false);

                  // Pages to display
                  return PageView(
                    controller: _controller,
                    children: [
                      TeamInfoPage(team: blueTeam, stats: info.blueStats, isBlue: true,),
                      AllSummoners(matchInfo: info),
                      TeamInfoPage(team: redTeam, stats: info.redStats, isBlue: false,),
                    ],
                  );
                },
              ),
            )
          ],
        )
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