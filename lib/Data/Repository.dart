import 'package:start_up_namer/Models/word_pair.dart';

class Repository {
  List<ParPalavras> pairList = [
    ParPalavras("Pato", "galatico"),
    ParPalavras("Start", "Upper"),
    ParPalavras("End", "Down"),
    ParPalavras("Smart", "Bee"),
    ParPalavras("Lip", "Log"),
    ParPalavras("Run", "Slope"),
    ParPalavras("Stack", "Rod"),
    ParPalavras("Foot", "Kind"),
    ParPalavras("Guard", "Shock"),
    ParPalavras("Dry", "Watch"),
    ParPalavras("Quick", "Fur"),
    ParPalavras("Neat", "Birth"),
    ParPalavras("Team", "Cow"),
    ParPalavras("Boat", "Jean"),
    ParPalavras("Wall", "Will"),
    ParPalavras("Harsh", "Stretch"),
    ParPalavras("Blank", "File"),
    ParPalavras("Theme", "Bed"),
    ParPalavras("Lung", "Crowd"),
    ParPalavras("Michael", "Jackson"),
    ParPalavras("Teste", "Bird"),
    ParPalavras("Fish", "Grande"),
  ];

  Listar() {
    return pairList;
  }

  ObterPorId(int index) {
    return pairList[index];
  }

  Inserir(ParPalavras pair) {
    pairList.add(pair);
  }

  Alterar(int index, ParPalavras pair) {
    pairList[index] = pair;
  }

  Deletar(int index) {
    pairList.removeAt(index);
  }
}
