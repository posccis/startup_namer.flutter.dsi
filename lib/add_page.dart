import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:start_up_namer/Data/Repository.dart';
import 'package:start_up_namer/Models/word_pair.dart';
import 'package:start_up_namer/main.dart';

class addPage extends StatefulWidget {
  addPage({Key? key}) : super(key: key);

  @override
  State<addPage> createState() => _addPageState();
}

class _addPageState extends State<addPage> {
  String firstWord = "";
  String secondtWord = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar'),
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
                  onChanged: (value) {
                    setState(() {
                      firstWord = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'Primeira Palavra',
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      secondtWord = value;
                    });
                  },
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
                      ParPalavras palavra = ParPalavras(firstWord, secondtWord);

                      Repository().Inserir(palavra);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RandomWords()));
                    });
                  },
                  child: Text('Editar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
