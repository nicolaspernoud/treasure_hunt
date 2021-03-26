import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treasurehunt/models/hunt.dart';

class PlayerView extends StatefulWidget {
  @override
  _PlayerViewState createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  var _givenAnswer = "";

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 800,
        child: Consumer<Hunt>(
          builder: (context, hunt, child) => Stepper(
            currentStep: hunt.activeStage,
            onStepCancel: () {
              if (hunt.activeStage <= 0) {
                return;
              }
              setState(() {
                hunt.activeStage--;
              });
            },
            onStepContinue: () async {
              if (hunt.activeStage >= hunt.stages.length - 1) {
                return;
              }
              if (hunt.stages[hunt.activeStage].answer == _givenAnswer) {
                setState(() {
                  hunt.nextStage();
                });
              } else {
                await showDialog(
                  context: context,
                  builder: (context) => new AlertDialog(
                    title: new Text('Wrong answer'),
                    content: Text(
                        'Your answer is not the one we were waiting for !'),
                    actions: <Widget>[
                      new TextButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .pop(); // dismisses only the dialog and returns nothing
                        },
                        child: new Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            steps: hunt.stages
                .map((e) => Step(
                    title: Text(e.title),
                    content: Column(
                      children: [
                        e.hintIsPlace ? Text(e.hint) : Text(e.hint),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Your answer',
                          ),
                          onChanged: (text) {
                            _givenAnswer = text;
                          },
                        )
                      ],
                    )))
                .toList(),
          ),
        ));
  }
}
