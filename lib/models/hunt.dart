import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesPersister {
  fromJson(String source);
  toJson();

  // Persistence
  read() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String contents = prefs.getString("hunt");
      fromJson(contents);
    } catch (e) {
      print("hunt could not be loaded from file, defaulting to new hunt");
    }
  }

  void write() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("hunt", toJson());
  }
}

class Hunt extends ChangeNotifier with SharedPreferencesPersister {
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
    _stages.add(Stage(
        "First stage", false, "The answer is : next stage", "next stage"));
    _stages.add(Stage("Second stage", false, "The answer is : next stage again",
        "next stage again"));
  }

  addStage(Stage s) {
    _stages.add(s);
    s.hunt = this;
    notifyAndPersist();
  }

  List<Stage> get stages => _stages;

  fromJson(String source) {
    Map huntMap = jsonDecode(source);
    _title = huntMap['_title'];
    _stages = (huntMap['_stages'] as List).map((e) {
      var st = Stage.fromJson(e);
      st.hunt = this;
      return st;
    }).toList();
  }

  String toJson() {
    Map<String, dynamic> huntMap = {'_title': title, '_stages': _stages};
    return jsonEncode(huntMap);
  }

  read() async {
    await super.read();
    notifyListeners();
  }

  notifyAndPersist() {
    notifyListeners();
    write();
  }
}

class Stage {
  String _title;
  bool _hintIsPlace;
  String _hint;
  String _answer;
  Stage(title, hintIsPlace, hint, answer) {
    this._title = title;
    this._hintIsPlace = hintIsPlace;
    this._hint = hint;
    this._answer = answer;
  }
  Hunt hunt;

  @override
  String toString() {
    return _title.toString();
  }

  String get title => this._title;
  set title(String value) {
    this._title = value;
    this.hunt.notifyAndPersist();
  }

  bool get hintIsPlace => this._hintIsPlace;
  set hintIsPlace(bool value) {
    this._hintIsPlace = value;
    this.hunt.notifyAndPersist();
  }

  String get hint => this._hint;
  set hint(String value) {
    this._hint = value;
    this.hunt.notifyAndPersist();
  }

  String get answer => this._answer;
  set answer(String value) {
    this._answer = value;
    this.hunt.notifyAndPersist();
  }

  remove() {
    this.hunt._stages.removeWhere((element) => element.title == _title);
    this.hunt.notifyAndPersist();
  }

  Map<String, dynamic> toJson() => {
        'title': _title,
        'hintIsPlace': _hintIsPlace,
        'hint': _hint,
        'answer': _answer
      };

  Stage.fromJson(Map<String, dynamic> json)
      : _title = json['title'],
        _hintIsPlace = json['hintIsPlace'],
        _hint = json['hint'],
        _answer = json['answer'];
}
