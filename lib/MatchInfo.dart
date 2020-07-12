import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Models/PastMatch.dart';
import 'Models/LiveMatch.dart';
import 'Networking/DDragonService.dart';

class MatchInfo extends StatefulWidget {
  MatchInfo({Key key, @required this.match}) :
      super(key: key);

  final PastMatch match;

  _MatchInfoState createState() => _MatchInfoState();
}

class _MatchInfoState extends State<MatchInfo> {

  @override
  Widget build(BuildContext context) {

    PastMatch currMatch = widget.match;

    return Scaffold(
      appBar: AppBar(
        title: Text(currMatch.gameId.toString())
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Hero(
            tag: widget.match.gameId.toString(),
            child: Material(
              type: MaterialType.transparency,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DDragonService.getChampIcon(
                      currMatch.champ.name,
                      imageWidth: 50
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(currMatch.champ.name),
                        Text(currMatch.lane, style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12
                        ),),
                      ],
                    ),
                  ),
                  Text(currMatch.dateTime.toLocal().toString())
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

}