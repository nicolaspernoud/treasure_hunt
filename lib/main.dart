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
      title: 'Treasure Hunt',
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
  var _adminMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            Center(child: Text("Admin mode")),
            Switch(
              value: _adminMode,
              onChanged: (v) {
                setState(() {
                  _adminMode = v;
                });
              },
            ),
          ],
        ),
        body: Center(
          child: _adminMode ? AdminView() : PlayerView(),
        ),
        floatingActionButton: _adminMode
            ? Consumer<Hunt>(
                builder: (context, hunt, child) => FloatingActionButton(
                      onPressed: () {
                        hunt.addStage(Stage("New stage", false,
                            "The answer is : new stage", "new stage"));
                      },
                      tooltip: 'Increment',
                      child: Icon(Icons.add),
                    ))
            : null);
  }
}
