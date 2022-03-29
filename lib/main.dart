// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:core';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:start_up_namer/Data/Repository.dart';
import 'package:start_up_namer/Models/word_pair.dart';

import 'package:start_up_namer/Routes/route.dart' as route;

void main() {
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
  final _suggestions = <ParPalavras>[];
  final _saved = <ParPalavras>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  late String firstWord;
  late String secondWord;
  

  @override
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
                        onPressed: _pushSaved,
                        icon: const Icon(Icons.list),
                        tooltip: 'Saved Suggestions',
                      )
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
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemBuilder: (BuildContext ctx, index) {
          final int qnt = index;
          if (qnt >= _suggestions.length) {
            _suggestions.addAll(Repository().Listar());
          }
          return _buildRow(_suggestions[qnt]);
        });
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int i) {
        if (i.isOdd) {
          return Divider();
        }
        final int index = i ~/ 2;

        if (index >= _suggestions.length) {
          _suggestions.addAll(Repository.instance.Listar());
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(ParPalavras pair) {
    final alreadySaved = _saved.contains(pair);
    final ParPalavras par;
    return ListTile(
      title: Text(
        pair.palavra,
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
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
      ),
      onTap: () {
        
        int index = Repository.instance.pairList
            .indexWhere((element) => element.palavra == pair.palavra);

        Navigator.pushNamed(context, route.EditPage, arguments: index);
        setState(() {
          RandomWords();
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      final tiles = _saved.map((pair) {
        return ListTile(
            title: Text(
          pair.palavra,
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
