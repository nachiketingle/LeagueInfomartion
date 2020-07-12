import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lolinfo/Helpers/AppThemes.dart';
import 'package:lolinfo/Models/Champion.dart';
import 'package:lolinfo/Models/ChampionMastery.dart';
import 'package:lolinfo/Networking/DDragonService.dart';
import 'package:lolinfo/Networking/RiotService.dart';
import 'Models/Summoner.dart';

class SummonerInfo extends StatefulWidget {
  SummonerInfo({Key key}) :
        super(key: key);

  _SummonerInfoState createState() => _SummonerInfoState();
}

class _SummonerInfoState extends State<SummonerInfo> {

  Summoner _displaySummoner;
  bool _sortAscending = false;
  List<int> _keys;
  Map<int, ChampionMastery> _allChamps = Map();
  int _sortColIndex = 0;

  List<DataRow> _rowsList() {
    List<DataRow> rows = List();
    for(int key in _keys) {
      DataRow row = DataRow(
          cells: [
            DataCell(
                Center(
                  child: Row(
                    children: [
                      DDragonService.getChampIcon(_allChamps[key].champ.name),
                      Text(_allChamps[key].champ.name),
                    ],
                  ),
                )
            ),
            DataCell(
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(_allChamps[key].champLevel.toString()),
                      Text(_allChamps[key].champPoints.toString(), style: TextStyle(color: Colors.grey),)
                    ],
                  ),
                )
            )
          ]
      );
      rows.add(row);
    }
    return rows;
  }

  void _onSortCol(int colIndex, bool ascending) {
    _sortColIndex = colIndex;
    if(colIndex == 0) {
      if(ascending) {
        _keys.sort((a, b) => _allChamps[a].champ.name.compareTo(_allChamps[b].champ.name));
      }
      else {
        _keys.sort((a, b) => _allChamps[b].champ.name.compareTo(_allChamps[a].champ.name));
      }
    }
    else if(colIndex == 1) {
      if(ascending) {
        _keys.sort((a, b) {
          return _allChamps[a].champLevel.compareTo(_allChamps[b].champLevel);
        });
      }
      else {
        _keys.sort((a, b) {
          return _allChamps[b].champLevel.compareTo(_allChamps[a].champLevel);
        });
      }

    }
  }


  Widget _dataTable() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: DataTable(
        sortAscending: _sortAscending,
        sortColumnIndex: _sortColIndex,
        columns: [
          DataColumn(
            label: Text("Champion"),
            onSort: (colIndex, ascending) {
              _onSortCol(colIndex, ascending);
              setState(() {
                _sortAscending = !_sortAscending;
              });

            }
          ),
          DataColumn(
              label: Center(child: Text("Mastery Level")),
              onSort: (colIndex, ascending) {
                _onSortCol(colIndex, ascending);
                setState(() {
                  _sortAscending = !_sortAscending;
                });

              }
          ),
        ],
        rows: _rowsList(),
      ),
    );
  }


  void initState() {
    super.initState();
  }

  Future<bool> _getDisplayInfo() async {
    if(_keys != null) {
      return true;
    }
    _displaySummoner = Summoner.selected;
    List<ChampionMastery> _list = await RiotService.getChampionMasteries(_displaySummoner.id).catchError((onError) {
      return false;
    });
    _allChamps.clear();
    for(ChampionMastery mastery in _list) {
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
        if(snapshot.hasData && snapshot.data == true) {
          return Center(
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Header(displaySummoner: _displaySummoner),
                  ),
                  Flexible(
                    flex: 5,
                    child: _dataTable(),
                  ),
                ],
              )
          );
        }
        else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

  }
}

class Header extends StatelessWidget {
  
  Header({@required this.displaySummoner});
  
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
                      image: displaySummoner.profileIcon.image
                  )
              ),
            )
        ),
      ],
    );
    
  }
}