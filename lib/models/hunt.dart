import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Hunt extends ChangeNotifier {
  String _title;
  String get title => this._title;
  set title(String value) => this._title = value;

  int _activeStage = 0;
  int get activeStage => this._activeStage;
  set activeStage(int value) {
    this._activeStage = value;
    notifyListeners();
  }

  nextStage() {
    this.activeStage = this.activeStage + 1;
  }

  var _stages = <Stage>[];

  Hunt(this._title) {
    addStage(Stage(
        "First stage", false, "The answer is : next stage", "next stage"));
  }

  notifyAndPersist() {
    notifyListeners();
    writeHunt();
  }

  addStage(Stage s) {
    _stages.add(s);
    notifyAndPersist();
  }

  List<Stage> get stages => _stages;

  // Persistence
  String _fileName = "hunt.json";

  Future<File> get localFile async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      await new Directory('${directory.path}').create(recursive: true);
      return File('${directory.path}/$_fileName');
    }
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  readHunt() async {
    try {
      final file = await localFile;
      String contents = await file.readAsString();
      fromJson(contents);
      notifyListeners();
    } catch (e) {
      print("hunt could not be loaded from file, defaulting to new hunt");
    }
  }

  void writeHunt() async {
    final file = await localFile;
    await file.writeAsString(toJson());
  }

  fromJson(String source) {
    Map huntMap = jsonDecode(source);
    _title = huntMap['_title'];
    _stages =
        (huntMap['_stages'] as List).map((e) => Stage.fromJson(e)).toList();
  }

  String toJson() {
    Map<String, dynamic> huntMap = {'_title': title, '_stages': _stages};
    return jsonEncode(huntMap);
  }
}

class Stage {
  String title;
  bool hintIsPlace;
  String hint;
  String answer;
  Stage(this.title, this.hintIsPlace, this.hint, this.answer);

  @override
  String toString() {
    return title.toString();
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'hintIsPlace': hintIsPlace,
        'hint': hint,
        'answer': answer
      };

  Stage.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        hintIsPlace = json['hintIsPlace'],
        hint = json['hint'],
        answer = json['answer'];
}
