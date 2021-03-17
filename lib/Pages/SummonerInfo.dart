import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lolinfo/Helpers/AppThemes.dart';
import 'package:lolinfo/Models/Champion.dart';
import 'package:lolinfo/Models/ChampionMastery.dart';
import 'package:lolinfo/Networking/DDragonService.dart';
import 'package:lolinfo/Networking/RiotService.dart';
import '../Models/Summoner.dart';

class SummonerInfo extends StatefulWidget {
  SummonerInfo({Key? key}) : super(key: key);

  _SummonerInfoState createState() => _SummonerInfoState();
}

class _SummonerInfoState extends State<SummonerInfo> {
  Summoner? _displaySummoner = Summoner.selected;
  List<int>? _keys;
  Map<int, ChampionMastery> _allChamps = Map();

  void initState() {
    super.initState();
  }

  Future<bool> _getDisplayInfo() async {
    if (_keys != null) {
      return true;
    }
    _displaySummoner = Summoner.selected;
    List<ChampionMastery> _list =
        await RiotService.getChampionMasteries(_displaySummoner!.id)
            .catchError((onError) {
      return false;
    });
    _allChamps.clear();
    for (ChampionMastery mastery in _list) {
      _allChamps[mastery.champId] = mastery;
    }

    _keys = _allChamps.keys.toList();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDisplayInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return Center(
              child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Header(displaySummoner: _displaySummoner!),
              ),
              Flexible(
                flex: 5,
                child: CustomDataTable(champMap: _allChamps),
              ),
            ],
          ));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class Header extends StatelessWidget {
  Header({required this.displaySummoner});

  final Summoner displaySummoner;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 40,
          left: 20,
          child: Text(
            displaySummoner.name,
            style: AppThemes.headerTitleStyle(),
          ),
        ),
        Positioned(
          top: 80,
          left: 20,
          child: Text(
            "Summoner Level: " + displaySummoner.summonerLevel.toString(),
            style: AppThemes.subheaderTitleStyle(),
          ),
        ),
        Positioned(
            top: 30,
            right: 20,
            child: Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: displaySummoner.profileIcon.image)),
            )),
      ],
    );
  }
}

class CustomDataTable extends StatefulWidget {
  CustomDataTable({Key? key, required this.champMap}) : super(key: key);
  final Map<int, ChampionMastery> champMap;

  _CustomDataTableState createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  late List<int> _keys;
  late Map<int, ChampionMastery> champMap;
  bool _nameSort = false;
  bool _nameAscending = true;

  bool _pointSort = false;
  bool _pointAscending = false;

  @override
  void initState() {
    super.initState();
    champMap = widget.champMap;
    _keys = champMap.keys.toList();
    _sortNames();
  }

  void _sortNames() {
    if (!_nameSort) {
      _nameSort = true;
      _pointSort = false;
    } else {
      _nameAscending = !_nameAscending;
    }

    _keys.sort((a, b) {
      if (_nameAscending) {
        return champMap[a]!.champ!.name!.compareTo(champMap[b]!.champ!.name!);
      } else {
        return champMap[b]!.champ!.name!.compareTo(champMap[a]!.champ!.name!);
      }
    });

    setState(() {});
  }

  void _sortPoints() {
    if (!_pointSort) {
      _pointSort = true;
      _nameSort = false;
    } else {
      _pointAscending = !_pointAscending;
    }

    _keys.sort((a, b) {
      if (_pointAscending) {
        return champMap[a]!.champPoints.compareTo(champMap[b]!.champPoints);
      } else {
        return champMap[b]!.champPoints.compareTo(champMap[a]!.champPoints);
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.075,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: _sortNames,
                  child: FractionallySizedBox(
                    heightFactor: 0.75,
                    child: Row(
                      children: <Widget>[
                        Text("Name"),
                        _nameSort
                            ? Icon(_nameAscending
                                ? Icons.arrow_upward
                                : Icons.arrow_downward)
                            : Container()
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: _sortPoints,
                  child: FractionallySizedBox(
                    heightFactor: 0.75,
                    child: Row(
                      children: <Widget>[
                        Text("Points"),
                        _pointSort
                            ? Icon(_pointAscending
                                ? Icons.arrow_upward
                                : Icons.arrow_downward)
                            : Container()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: widget.champMap.length,
              itemBuilder: (context, index) {
                return ChampTile(champMastery: champMap[_keys[index]]!);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChampTile extends StatelessWidget {
  ChampTile({Key? key, required this.champMastery}) : super(key: key);
  ChampionMastery champMastery;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Container(
        width: MediaQuery.of(context).size.height * 0.9,
        height: MediaQuery.of(context).size.height * 0.11,
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //Container(),
                DDragonService.getChampIcon(champMastery.champ!.name!),
                Column(
                  children: <Widget>[
                    Expanded(
                        child: DDragonService.getMasteryIcon(
                            champMastery.champLevel)),
                    Text(
                      champMastery.champPoints.toString(),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
