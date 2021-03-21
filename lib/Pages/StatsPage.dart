import 'package:flutter/material.dart';
import 'package:lolinfo/Models/PastMatch.dart';

class StatsPage extends StatefulWidget {
  StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {

  Future<List<PastMatch>> _getMatches() async {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getMatches(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator(),);

        return Text("Got Data");
      },
    );
  }
}
