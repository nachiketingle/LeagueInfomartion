import 'package:flutter/material.dart';
import 'package:lolinfo/Networking/DDragonService.dart';
import 'package:lolinfo/Pages/AllPages.dart';
import 'dart:core';

import 'package:lolinfo/Pages/StatsPage.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  static PageStorageKey _summonerListKey = PageStorageKey('SummonerList');
  int _selectedIndex = 0;
  late PageController _pageController;
  List<Widget> bodies = [
    SummonerList(key: _summonerListKey,),
    SummonerInfo(),
    MatchHistory(),
    LiveMatchPage(),
    StatsPage(),
  ];

  void _onTappedItem(int index) {
    if((index - _selectedIndex).abs() == 1) {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.animateToPage(_selectedIndex, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
    else {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.jumpToPage(_selectedIndex);
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _pageController = PageController(initialPage: _selectedIndex);

    // Initializes the list
    DDragonService.getAllChampions();
    DDragonService.getAllSummonerSpells();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Opacity(
              opacity: 0.75,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue, Colors.red]),
                ),
              ),
            ),
            PageView(
              children: bodies,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.blue,
        onTap: _onTappedItem,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: "Summoners"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Summoner Info"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: "Match History"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.live_help),
              label: "Live Match"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.info_sharp),
              label: "Stats"
          ),
        ],
      ),
    );
  }

}