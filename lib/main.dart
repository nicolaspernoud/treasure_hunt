import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treasurehunt/components/admin.dart';
import 'package:treasurehunt/components/player.dart';

import 'models/hunt.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var h = Hunt("My hunt");
  h.readHunt();
  runApp(
    ChangeNotifierProvider.value(
      value: h,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Treasure Hunt'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _adminMode),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[AdminView()],
        ),
      ),
    );
  }

  void _adminMode() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Admin mode'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[PlayerView()],
                ),
              ),
              floatingActionButton: Consumer<Hunt>(
                  builder: (context, hunt, child) => FloatingActionButton(
                        onPressed: () {
                          hunt.addStage(Stage("New stage", false,
                              "The answer is : new stage", "new stage"));
                        },
                        tooltip: 'Increment',
                        child: Icon(Icons.add),
                      ))); // This trailing comma makes auto-formatti;
        },
      ),
    );
  }
}
