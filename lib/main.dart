// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:flutter/material.dart';
import 'package:start_up_namer/Data/Repository.dart';
import 'package:start_up_namer/Models/word_pair.dart';

import 'package:start_up_namer/Routes/route.dart' as route;
import 'package:start_up_namer/add_page.dart';
import 'firebase_options.dart';

void main() async {
  /*WidgetsFlutterBinding.ensureInitialized();*/

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateRoute: route.controller,
        title: 'Welcome to Flutter',
        home: RandomWords());
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class AppController extends ChangeNotifier {
  static AppController instance = AppController();

  bool isSwitched = false;
  changeView() {
    isSwitched = !isSwitched;
    notifyListeners();
  }
}

class _RandomWordsState extends State<RandomWords> {
  late var collection;
  List<ParPalavras> _suggestions = <ParPalavras>[];
  final _saved = <ParPalavras>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  late String firstWord;
  late String secondWord;
  List<String> _salvos = <String>[];
  var _results;
  int quant = 20;

  @override
  void initState() {
    super.initState();
    init();
    getFavs().then((a) {
      setState(() {
        _salvos = a;
      });
    });
  }

  void init() async {
    collection = FirebaseFirestore.instance.collection('Favoritos');
  }

  Future<List<String>> getFavs() async {
    _results = await collection.get();
    List<String> mizera = [];
    for (var doc in _results.docs) {
      setState(() {
        _salvos.add(doc["ParPalava"].toString());
        mizera.add(doc["ParPalava"].toString());
      });
    }

    return mizera;
  }

  remover(String palavra) async {
    await collection.doc(palavra).delete();
  }

  like(String palavra) async {
    await collection.doc(palavra).set({"ParPalava": palavra});
  }

  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: AppController.instance,
        builder: (context, child) {
          return MaterialApp(
              home: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'StartUp Name Generator',
                      style: TextStyle(color: Colors.black),
                    ),
                    actions: [
                      Center(
                        child: Switch(
                          value: AppController.instance.isSwitched,
                          onChanged: (value) {
                            AppController.instance.changeView();
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, route.AddPage);
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        tooltip: 'Adicionar',
                      ),
                      IconButton(
                        tooltip: 'Sugestões salvas',
                        icon: const Icon(Icons.list, color: Colors.black),
                        onPressed: _pushSaved,
                      ),
                    ],
                    titleTextStyle: TextStyle(color: Colors.black),
                    backgroundColor: Colors.white,
                  ),
                  body: AppController.instance.isSwitched
                      ? _buildGridView()
                      : _buildSuggestions()));
        });
  }

  Widget _buildGridView() {
    //usar gridview builder
    _suggestions = Repository().Listar();
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: _suggestions.length,
        itemBuilder: (BuildContext ctx, int i) {
          return _buildRow(_suggestions[i].palavra);
        });
  }

  Widget _buildSuggestions() {
    _suggestions = Repository().Listar();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _suggestions.length,
      itemBuilder: (BuildContext _context, int i) {
        return _buildRow(_suggestions[i].palavra);
      },
    );
  }

  Widget _buildRow(String pair) {
    getFavs().then((a) {
      setState(() {
        _salvos = a;
      });
    });
    var alreadySaved = _salvos.contains(pair);
    final ParPalavras par;
    return ListTile(
      title: Text(
        pair,
        style: _biggerFont,
      ),
      tileColor: Colors.white10,
      trailing: GestureDetector(
        child: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
          semanticLabel: alreadySaved ? 'Remove from favorites' : 'Save',
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              remover(pair);
            } else {
              like(pair);
            }
          });
        },
      ),
      onTap: () {
        int index =
            Repository().pairList.indexWhere((element) => element == pair);

        Navigator.pushNamed(context, route.EditPage, arguments: index);
        setState(() {
          RandomWords();
        });
      },
    );
  }

  void _pushSaved() async {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      final tiles = _salvos.map((pair) {
        return ListTile(
            title: Text(
          pair,
          style: _biggerFont,
        ));
      });
      final divided = tiles.isNotEmpty
          ? ListTile.divideTiles(context: context, tiles: tiles).toList()
          : <Widget>[];

      return Scaffold(
        appBar: AppBar(
          title: const Text("Saved Suggestions"),
        ),
        body: ListView(children: divided),
      );
    }));
  }
}
