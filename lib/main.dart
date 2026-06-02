import 'package:flutter/material.dart';

void main() {
  runApp(const OpenThePathGame());
}

class OpenThePathGame extends StatelessWidget {
  const OpenThePathGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Open The Path',
      theme: ThemeData.dark(),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double playerX = 50;
  bool gameOver = false;
  int level = 1;

  void movePlayer() {
    if (gameOver) return;

    setState(() {
      playerX += 20;

      if (playerX > 300) {
        level++;
        playerX = 50;
        showWinDialog();
      }
    });
  }

  void showWinDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("نجحت!"),
        content: Text("وصلت للمرحلة $level"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("متابعة"),
          )
        ],
      ),
    );
  }

  void showGameOver() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("خسرت"),
        content: const Text("اختر ماذا تريد"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                playerX = 50;
                gameOver = false;
              });
              Navigator.pop(context);
            },
            child: const Text("إعادة"),
          ),
          TextButton(
            onPressed: () {
              // مكان إعلان لاحق
              setState(() {
                playerX = 50;
                gameOver = false;
              });
              Navigator.pop(context);
            },
            child: const Text("مشاهدة إعلان والمتابعة"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            left: playerX,
            top: 200,
            child: Container(
              width: 40,
              height: 40,
              color: Colors.blue,
            ),
          ),

          Positioned(
            bottom: 50,
            left: 50,
            child: ElevatedButton(
              onPressed: movePlayer,
              child: const Text("تحرك"),
            ),
          ),

          Positioned(
            bottom: 50,
            right: 50,
            child: ElevatedButton(
              onPressed: showGameOver,
              child: const Text("خسارة (تجريب)"),
            ),
          ),
        ],
      ),
    );
  }
}
