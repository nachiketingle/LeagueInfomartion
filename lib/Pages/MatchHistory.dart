import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lolinfo/Models/PastMatch.dart';
import 'package:lolinfo/Models/Summoner.dart';
import 'package:lolinfo/Networking/DDragonService.dart';
import 'package:lolinfo/Networking/RiotService.dart';
import 'package:lolinfo/Pages/MatchInfo.dart';

class MatchHistory extends StatefulWidget {
  MatchHistory({Key key}) :
        super(key: key);

  _MatchHistoryState createState() => _MatchHistoryState();
}

class _MatchHistoryState extends State<MatchHistory> {

  Future<List<PastMatch>> _getMatches() async {
    if(Summoner.selected == null)
      return null;
    return await RiotService.getMatchHistory(Summoner.selected.accountId);
  }
  
  Route _createRoute(PastMatch match) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MatchInfo(match: match,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin = Offset(0.0, 1.0);
        Offset end = Offset.zero;
        Curve curve = Curves.easeInOut;
        Tween tween = Tween<Offset>(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder (
      future: _getMatches(),
      builder: (context, snapshot) {
        if(snapshot.hasData && snapshot.data != null) {
          List<PastMatch> matches = snapshot.data;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                PastMatch currMatch = matches[index];
                return Card(
                  child: FlatButton(
                    onPressed: () {
                      // TODO: Display match info
                      Navigator.of(context).push(_createRoute(currMatch));
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: <Widget>[
                            Hero(
                              tag: currMatch.gameId.toString(),
                              child: Material(
                                type: MaterialType.transparency,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    DDragonService.getChampIcon(
                                        currMatch.champ.name,
                                        imageWidth: 50
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(currMatch.champ.name),
                                        Text(currMatch.lane, style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12
                                        ),),
                                      ],
                                    ),
                                    Text(currMatch.dateTime.toLocal().toString())
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        else {
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );

  }

}