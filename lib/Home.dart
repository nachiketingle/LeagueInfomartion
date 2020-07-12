import 'package:flutter/material.dart';
import 'package:lolinfo/MatchHistory.dart';
import 'package:lolinfo/SummonerInfo.dart';
import 'package:lolinfo/SummonerList.dart';
import 'LiveMatchPage.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  static PageStorageKey _summonerListKey = PageStorageKey('SummonerList');
  int _selectedIndex;
  PageController _pageController;
  List<Widget> bodies = [
    SummonerList(key: _summonerListKey,),
    SummonerInfo(),
    MatchHistory(),
    LiveMatchPage()
  ];

  void _onTappedItem(int index) {

    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(_selectedIndex, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: PageView(
          children: bodies,
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
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
            title: Text("Summoners")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Summoner Info")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text("Match History")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.live_help),
              title: Text("Live Match")
          ),
        ],
      ),
    );
  }

}