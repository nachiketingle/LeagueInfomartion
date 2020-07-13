import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lolinfo/Models/LiveMatch.dart';
import 'package:lolinfo/Models/MatchParticipant.dart';
import 'package:lolinfo/Models/Summoner.dart';
import 'package:lolinfo/Networking/DDragonService.dart';
import 'package:lolinfo/Networking/RiotService.dart';

class LiveMatchPage extends StatefulWidget {

  _LiveMatchPageState createState() => _LiveMatchPageState();
}

class _LiveMatchPageState extends State<LiveMatchPage> {

  Future<LiveMatch> getLiveMatch() async {
    return RiotService.getLiveMatch(Summoner.selected.id);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: getLiveMatch(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              LiveMatch match = snapshot.data;
              return ListView.builder(
                itemCount: match.blueSide.length,
                itemBuilder: (context, index) {
                  return LaneMatchup(
                    blue: match.blueSide[index],
                    red: match.redSide[index],
                  );
                },
              );
            }
            else if(snapshot.connectionState == ConnectionState.done) {
              return Text("Live Match not Found");
            }
            else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

}

class LaneMatchup extends StatelessWidget {

  LaneMatchup({Key key, this.blue, this.red}) :
        super(key: key);

  final MatchParticipant blue;
  final MatchParticipant red;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.16,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue,
                Colors.red,
              ]
          ),
        ),
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Side(participant: blue,),
                Side(participant: red, isBlue: false,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Side extends StatelessWidget {
  Side({Key key, @required this.participant, this.isBlue: true}) :
        super(key: key);
  final MatchParticipant participant;
  final bool isBlue;

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: isBlue ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            participant.summonerName,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          DDragonService.getChampIcon(participant.champion.name, imageHeight: 75)
        ],
      ),
    );
  }

}