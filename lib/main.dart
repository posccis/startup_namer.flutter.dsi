// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:core';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:start_up_namer/edit_page.dart';

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
    final wordPair = WordPair.random();
    return MaterialApp(title: 'Welcome to Flutter', home: RandomWords());
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
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
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
            _suggestions.addAll(generateWordPairs().take(10));
            
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
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
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
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => editPage(context, pair)));
      },
    );
  }

  Widget editPage(BuildContext context, WordPair pair) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pair.toString()),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  onChanged: (value) => {firstWord = value},
                  decoration: InputDecoration(
                      labelText: 'Primeira Palavra',
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (value) => {secondWord = value},
                  decoration: InputDecoration(
                      labelText: 'Segunda Palavra',
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 13,
                ),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      _suggestions[_suggestions.indexOf(pair)] =
                          WordPair(firstWord, secondWord);
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Editar'),
                ),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      _suggestions
                          .remove(_suggestions[_suggestions.indexOf(pair)]);
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Apagar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      final tiles = _saved.map((pair) {
        return ListTile(
            title: Text(
          pair.asPascalCase,
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
