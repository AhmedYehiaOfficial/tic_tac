import 'package:flutter/material.dart';
import 'package:xo/game_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = '';
  Game game = Game();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            SwitchListTile.adaptive(
              title: const Text(
                'Turn on/off two players',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              value: isSwitched,
              onChanged: (bool newValue) {
                setState(() {
                   isSwitched=newValue;
                });
              },
            ),
            Text(
              'It\'s $activePlayer Turn'.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
                child: GridView.count(
              padding: const EdgeInsets.all(18),
              childAspectRatio: 1,
              mainAxisSpacing: 50.0,
              crossAxisSpacing: 15.0,
              crossAxisCount: 3,
              children: List.generate(
                  9,
                  (index) => InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: gameOver ? null : () {
                                _onTap(index);
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              Player.playerX.contains(index)
                                  ? 'X'
                                  : Player.playerO.contains(index)
                                      ? 'O'
                                      : '',
                              style: TextStyle(
                                color: Player.playerX.contains(index)
                                    ? Colors.white
                                    : Colors.pink,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )),
            )),
            Text(
              result,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
              ),
              textAlign: TextAlign.center,
            ),
            ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).splashColor)),
                onPressed: () {
                  setState(() {
                    Player.playerX = [];
                    Player.playerO = [];
                    activePlayer = 'X';
                    gameOver = false;
                    turn = 0;
                    result = '';
                  });
                },
                icon: const Icon(Icons.replay),
                label: const Text('Repeat the Game'))
          ],
        ),
      ),
    );
  }

  void _onTap(int index) async {

    if ((!Player.playerX.contains(index) ||
        Player.playerX.isEmpty) &&
        (!Player.playerO.contains(index) ||
        Player.playerO.isEmpty)) {
      game.playGame(index, activePlayer);
      updateState();

      if(!isSwitched && !gameOver && turn!=9){
        await game.autoPlay(activePlayer);
        updateState();

      }
    }

  }

  void updateState() {
    setState(() {
      activePlayer = activePlayer == 'X' ? 'O' : 'X';
      turn++;
      String winnerPlayer = game.checkWinner();
      if(winnerPlayer != ''){
        result='${winnerPlayer} is the Winner';
      }else if(!gameOver && turn==9){
        result='DRAW';
      }
    });
  }
}
