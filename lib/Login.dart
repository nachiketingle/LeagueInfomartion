import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _summonerNameController = TextEditingController();
  String text = '';
  void _getSummonerInfo() async{
    //text = await RiotService.getSummonerInfo(_summonerNameController.text);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Summoner Name"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(text),
            TextField(
              controller: _summonerNameController,
              decoration: InputDecoration(
                  hintText: "Summoner Name"
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _getSummonerInfo();
        },
        label: Text("Get Info"),),
    );
  }

}