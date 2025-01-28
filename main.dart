import 'package:flutter/material.dart';
import 'dart:math';
import 'wordbank.dart';
void main() => runApp( const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({
    super.key
  });


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Wordle(),
    );
  }
}

class Wordle extends StatefulWidget {
  const Wordle({
    super.key
  });

  @override
  State<Wordle> createState() => _WordleState();
}

class _WordleState extends State<Wordle> {
  final List<String> wordBank = wordbank;
  late String correctword = wordBank[Random().nextInt(wordBank.length)];
  bool instructions = false;
  int attempts = 1;
  bool correctguess = false;
  String wordguess = "";
  List<Widget> guesslist = <Widget>[];
 
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final wordguess = _controller.text.toUpperCase();
      setState(() => this.wordguess = wordguess);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setInstructions() {
    setState(() {
      instructions = !instructions;
    });
  }

  void submitGuess() {
    List <int> wordCheck = [0, 0, 0, 0, 0];
    List <String> remainingCorrectLetters = correctword.split("");
    List <String> remainingGuessLetters = wordguess.split("");
    int c = 0;
    while (c < 5) {
      if (remainingCorrectLetters[c] == remainingGuessLetters[c]) {
        wordCheck[c] = 3;
        remainingCorrectLetters[c] = "!";
        remainingGuessLetters[c] = "!";
      }
      c++;
    }
    if (wordguess == correctword) {
      setState(() {correctguess = true;});
    }
    else {
      int w = 0;
      while (w < 5) {
        if (wordCheck[w] == 0 && !remainingCorrectLetters.contains(remainingGuessLetters[w])) {
          wordCheck[w] = 1;
        }
        w++;
      }
      int i = 0;
      while (i < 5) {
        if (wordCheck[i] == 0) {
          int j = 0;
          while (j < 5) {
            if (remainingGuessLetters[i] == remainingCorrectLetters[j]) {
              wordCheck[i] = 2;
              remainingGuessLetters[i] = "?";
              remainingCorrectLetters[j] = "?";
              break;
            }
            j++;
          }
          if (wordCheck[i] == 0) {
            wordCheck[i] = 1;
          }
        }
        i++;
      }
      setState(() {attempts = attempts + 1;});
    }
    setState(() {guesslist = [...guesslist, RichText(text: TextSpan(children: [
      if (wordCheck[0] == 1) TextSpan(text: wordguess[0], style: const TextStyle(color: Colors.red, fontSize: 50)),
      if (wordCheck[0] == 2) TextSpan(text: wordguess[0], style: const TextStyle(color: Colors.orange, fontSize: 50)),
      if (wordCheck[0] == 3) TextSpan(text: wordguess[0], style: const TextStyle(color: Colors.green, fontSize: 50)),
      if (wordCheck[1] == 1) TextSpan(text: wordguess[1], style: const TextStyle(color: Colors.red, fontSize: 50)),
      if (wordCheck[1] == 2) TextSpan(text: wordguess[1], style: const TextStyle(color: Colors.orange, fontSize: 50)),
      if (wordCheck[1] == 3) TextSpan(text: wordguess[1], style: const TextStyle(color: Colors.green, fontSize: 50)),
      if (wordCheck[2] == 1) TextSpan(text: wordguess[2], style: const TextStyle(color: Colors.red, fontSize: 50)),
      if (wordCheck[2] == 2) TextSpan(text: wordguess[2], style: const TextStyle(color: Colors.orange, fontSize: 50)),
      if (wordCheck[2] == 3) TextSpan(text: wordguess[2], style: const TextStyle(color: Colors.green, fontSize: 50)),
      if (wordCheck[3] == 1) TextSpan(text: wordguess[3], style: const TextStyle(color: Colors.red, fontSize: 50)),
      if (wordCheck[3] == 2) TextSpan(text: wordguess[3], style: const TextStyle(color: Colors.orange, fontSize: 50)),
      if (wordCheck[3] == 3) TextSpan(text: wordguess[3], style: const TextStyle(color: Colors.green, fontSize: 50)),
      if (wordCheck[4] == 1) TextSpan(text: wordguess[4], style: const TextStyle(color: Colors.red, fontSize: 50)),
      if (wordCheck[4] == 2) TextSpan(text: wordguess[4], style: const TextStyle(color: Colors.orange, fontSize: 50)),
      if (wordCheck[4] == 3) TextSpan(text: wordguess[4], style: const TextStyle(color: Colors.green, fontSize: 50)),
    ]),)];});
  }

  void restartGame() {
    setState(() {attempts = 1;});
    setState(() {correctguess = false;});
    setState(() {guesslist = [];});
    setState(() {correctword = wordBank[Random().nextInt(wordBank.length)];});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Guess a 5-letter word:"),
          TextField(
            controller: _controller
          ),
          if (wordguess.length == 5 && RegExp(r'^[A-Za-z]+$').hasMatch(wordguess) && attempts < 7 && correctguess == false) ElevatedButton(
            onPressed: submitGuess,
            child: const Text("Enter")
          ),
          if (wordguess.length != 5 || !RegExp(r'^[A-Za-z]+$').hasMatch(wordguess) || attempts > 6 || correctguess == true) const ElevatedButton(
            onPressed: null,
            child: Text("Enter")
          ),
          if (!instructions) ElevatedButton(
            onPressed: setInstructions, 
            child: const Text("How to play")
          ),
          if (instructions) ElevatedButton(
            onPressed: setInstructions,
            child: const Text("Close instructions")
          ),
          ...guesslist,
          if (correctguess) const Text("You guessed the word! Congratulations!"),
          if (attempts > 6) Text("The correct word is $correctword"),
          if (correctguess || attempts > 6) const Text("Play again?"),
          if (correctguess || attempts > 6) ElevatedButton(onPressed: restartGame, child: const Text("Play again")),
          if (instructions) const Text("Each guess must be a 5-letter word. You have 6 attempts to guess the correct word."),
          if (instructions) RichText(text: const TextSpan(children: [
            TextSpan(text: "Green", style: TextStyle(color: Colors.green)),
            TextSpan(text: " indicates the letter is in the correct slot.\n", style: TextStyle(color: Colors.black)),
            TextSpan(text: "Orange", style: TextStyle(color: Colors.orange)),
            TextSpan(text: " indicates the letter is in the correct word but in the wrong slot.\n", style: TextStyle(color: Colors.black)),
            TextSpan(text: "Red", style: TextStyle(color: Colors.red)),
            TextSpan(text: " indicates the letter is not in the correct word.", style: TextStyle(color: Colors.black))
          ]))
        ],
      )
    );
  }
}
