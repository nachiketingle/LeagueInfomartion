import 'package:flutter/material.dart';
import 'package:lolinfo/Home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark
      ),
      routes: {
        '/': (context) => Home(),
      },
      initialRoute: '/',
    );
  }
}
