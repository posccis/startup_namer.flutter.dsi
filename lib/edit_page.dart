import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:start_up_namer/main.dart';

class editPage extends StatefulWidget {
  late String firstWord;

  late String secondtWord;

  editPage({Key? key}) : super(key: key);

  @override
  State<editPage> createState() => _editPageState(firstWord, secondtWord);
}

class _editPageState extends State<editPage> {

  _editPageState(this.firstWord, this.secondtWord);
  late String firstWord;
  late String secondtWord;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onChanged: (value) => {secondtWord = value},
                  decoration: InputDecoration(
                      labelText: 'Segunda Palavra',
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 13,
                ),
                RaisedButton(
                  onPressed: () {
                    List<String> valornovo() {
                      List<String> lista = [firstWord, secondtWord];
                      return lista;
                    }
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

  List<String> valornovo() {
    List<String> lista = [firstWord, secondtWord];
    return lista;
  }
}
