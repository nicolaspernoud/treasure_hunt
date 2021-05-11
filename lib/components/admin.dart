import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treasurehunt/models/hunt.dart';

class AdminView extends StatefulWidget {
  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 800,
        child: Consumer<Hunt>(
            builder: (context, hunt, child) => SingleChildScrollView(
                  child: Wrap(
                    runSpacing: 20,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: hunt.stages
                        .map((e) => Card(
                            child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Wrap(
                                        runSpacing: 20,
                                        children: [
                                          TextFormField(
                                            initialValue: e.title,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Step title',
                                            ),
                                            onChanged: (text) {
                                              e.title = text;
                                            },
                                          ),
                                          SwitchListTile(
                                            title: const Text(
                                                'Hint is a location'),
                                            value: e.hintIsPlace,
                                            onChanged: (v) {
                                              e.hintIsPlace = v;
                                            },
                                            secondary: const Icon(Icons.map),
                                          ),
                                          TextFormField(
                                            initialValue: e.hint,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Hint',
                                            ),
                                            onChanged: (text) {
                                              e.hint = text;
                                            },
                                          ),
                                          TextFormField(
                                            initialValue: e.answer,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Answer',
                                            ),
                                            onChanged: (text) {
                                              e.answer = text;
                                            },
                                          ),
                                        ],
                                      ),
                                    ]))))
                        .toList(),
                  ),
                )));
  }
}
