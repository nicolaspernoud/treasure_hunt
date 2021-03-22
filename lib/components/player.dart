import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treasurehunt/models/hunt.dart';

class PlayerView extends StatefulWidget {
  @override
  _PlayerViewState createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
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
                onStepContinue: () {
                  if (hunt.activeStage >= hunt.stages.length - 1) {
                    return;
                  }
                  setState(() {
                    hunt.nextStage();
                  });
                },
                steps: hunt.stages
                    .map((e) => Step(
                          title: Text(e.title),
                          content: Container(
                              alignment: Alignment.centerLeft,
                              child:
                                  e.hintIsPlace ? Text(e.hint) : Text(e.hint)),
                        ))
                    .toList(),
              )),
    );
  }
}
