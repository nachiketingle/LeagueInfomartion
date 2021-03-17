import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lolinfo/Helpers/AppThemes.dart';
import 'package:lolinfo/Helpers/DeviceInfo.dart';
import 'package:lolinfo/Models/Summoner.dart';
import 'package:lolinfo/Networking/RiotService.dart';
import 'package:lolinfo/CustomWidgets/ImageHolders.dart';

class SummonerList extends StatefulWidget {
  SummonerList({Key? key}) :
        super(key: key);

  _SummonerListState createState() => _SummonerListState();
}

class _SummonerListState extends State<SummonerList> {

  TextEditingController _summonerNameController = TextEditingController();
  static Map<String, Summoner> _summonerList = Map();
  final double _sidePadding = 50;
  FocusNode myFocusNode = FocusNode();
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey<AnimatedListState>();

  /// Add a new summoner name
  void _submitName() {
    print(_summonerList.length);

    if(_summonerList.length > 10) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Too many Summoners. Delete some to add more"),
      ));
      return;
    }
    RiotService.getSummonerInfo(_summonerNameController.text.trim()).then((summoner) {
      if(summoner == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Unable to get Summoner"),
        ));
        return;
      }

      if(_summonerList.isEmpty) {
        _updateSelectedSummoner(summoner);
      }
      else {
        summoner.isSelected = false;
      }

      if(!_summonerList.containsKey(summoner.puuid)) {
        print("Added value");
        //setState(() {
        _summonerList[summoner.puuid] = summoner;
        List<String> _keys = _getSortedKeys();
        _animatedListKey.currentState!.insertItem(_keys.indexOf(summoner.puuid));
        //});
        DeviceInfo.loadSharedPreferences().then((value) {
          value.setStringList("puuid", _summonerList.keys.toList());
        });
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Already have Summoner"),
        ));
      }
    });
  }

  /// Determine which icon to use on the search tab
  Widget _searchIcon(BuildContext context) {
    if(_summonerNameController.text.length <= 0) {
      return IconButton(
        icon: Icon(Icons.add_circle),
        onPressed: () {
          myFocusNode.requestFocus();
        },
      );
    }
    else {
      return IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          setState(() {
            FocusScope.of(context).unfocus();
            _summonerNameController.clear();
          });
        },
      );
    }
  }

  /// Create a card for each summoner
  Widget _cardBuilder(Summoner summoner, Color color, int index, BuildContext context, Animation<double> animation) {
    return SizeTransition(
      key: ValueKey<int>(index),
      sizeFactor: animation,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _updateSelectedSummoner(summoner);
            });
          },
          child: Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              _summonerList.remove(summoner.puuid);
              if(summoner.isSelected) {
                _updateSelectedSummoner(null);
              }

              _animatedListKey.currentState!.removeItem(index, (context, animation) {
                return PlaceholderCard(height: MediaQuery.of(context).size.height * 0.1, animation: animation,);
              },
              duration: Duration(milliseconds: 250));

              DeviceInfo.loadSharedPreferences().then((value) {
                value.setStringList('puuid', _summonerList.keys.toList());
              });
            },
            child: SummonerCard(color: color, summoner: summoner),
          ),
        ),
      ),
    );
  }

  /// Update selected user
  void _updateSelectedSummoner(Summoner? selected) {
    if(Summoner.selected != null) {
      Summoner.selected!.isSelected = false;
    }

    if (selected == null) {
      Summoner.selected = null;
      DeviceInfo.loadSharedPreferences().then((value) {
        value.remove('selected');
      });
    }
    else {
      selected.isSelected = true;
      Summoner.selected = selected;
      DeviceInfo.loadSharedPreferences().then((value) {
        value.setString('selected', selected.puuid);
      });
    }
  }

  /// Get summoners from the preferences
  void _loadSummonerFromPreferences() async {
    DeviceInfo.loadSharedPreferences().then((value) async {
      if(_summonerList.isNotEmpty)
        return;

      List<String> keys;
      if (value.containsKey('puuid')) {
        keys = value.getStringList('puuid')!;
      }
      else {
        return;
      }

      String _selectedKey = '';
      if(value.containsKey('selected')) {
        _selectedKey = value.getString('selected')!;
      }

      for(String key in keys) {
        if(_summonerList.containsKey(key)) {
          continue;
        }
        else {
          final currSummoner = await RiotService.getSummonerFromPUUID(key);
          if(_summonerList.isEmpty && _selectedKey.compareTo('') == 0) {
            _updateSelectedSummoner(currSummoner);
          }
          else if(currSummoner.puuid.compareTo(_selectedKey) == 0) {
            _updateSelectedSummoner(currSummoner);
          }
          else {
            currSummoner.isSelected = false;
          }
          _summonerList[key] = currSummoner;

        }
      }

      List<String> _keys = _getSortedKeys();
      for(int i=0; i < _keys.length; i++) {
        _animatedListKey.currentState!.insertItem(i);
      }

    });
  }

  List<String> _getSortedKeys() {
    List<String> _keys = _summonerList.keys.toList();
    _keys.sort((a, b) {
      return _summonerList[a]!.name.compareTo(_summonerList[b]!.name);
    });
    return _keys;
  }

  @override
  void initState() {
    super.initState();
    _loadSummonerFromPreferences();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.fromLTRB(_sidePadding, 20, _sidePadding, 0),
      child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  _searchIcon(context),
                  Expanded(
                    child: TextField(
                      controller: _summonerNameController,
                      textAlign: TextAlign.center,
                      focusNode: myFocusNode,
                      decoration: InputDecoration(
                          hintText: "Enter New Summoner"
                      ),
                      onChanged: (text) {
                        setState(() { });
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        _submitName();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox.fromSize(
                size: Size.fromHeight(10),
              ),
              Expanded(
                child: AnimatedList(
                  key: _animatedListKey,
                  initialItemCount: _summonerList.keys.length,
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index, animation) {
                    List<String> _keys = _getSortedKeys();
                    String key = _keys[index];
                    Summoner currSummoner = _summonerList[key]!;
                    Color color = currSummoner.isSelected ? Colors.green : Colors.red;
                    return _cardBuilder(currSummoner, color, index, context, animation);
                  },
                ),
              ),
            ],
          )
      ),
    );
  }
}

class SummonerCard extends StatelessWidget {
  SummonerCard({Key? key, required this.color, required this.summoner}) :
        super(key: key);

  final Color color;
  final Summoner summoner;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              summoner.name,
              style: AppThemes.listCardStyle(),
            ),
            CircularImage(
              image: summoner.profileIcon,
              diameter: 50,
            )
          ],
        ),
      ),
    );
  }
}

class PlaceholderCard extends StatelessWidget {
  PlaceholderCard({Key? key, required this.height, required this.animation}) :
    super(key: key);

  final double height;
  final Animation<double> animation;

  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: Container(height: height,),
    );
  }

}