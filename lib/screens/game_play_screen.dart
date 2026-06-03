import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/open_the_path_game.dart';
import '../game/audio_manager.dart';
import '../services/ad_manager.dart';

class GamePlayScreen extends StatefulWidget {
  const GamePlayScreen({Key? key}) : super(key: key);

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  late OpenThePathGame _game;
  final AdManager _adManager = AdManager();
  
  bool _isGameOver = false;
  bool _isLevelComplete = false;
  int _currentLevel = 1;

  @override
  void initState() {
    super.initState();
    // تهيئة الإعلانات مسبقاً
    _adManager.loadInterstitial();
    _adManager.loadRewarded();

    // بناء محرك اللعبة وربطه بأحداث الشاشة
    _game = OpenThePathGame(
      onGameOver: () {
        AudioManager.playGameOver();
        setState(() => _isGameOver = true);
      },
      onLevelComplete: () {
        AudioManager.playWin();
        setState(() => _isLevelComplete = true);
      },
    );
  }

  // إعادة اللعب من نقطة البداية
  void _restartFromStart() {
    setState(() {
      _isGameOver = false;
    });
    _game.startLevel();
  }

  // متابعة اللعب من نفس النقطة بعد مشاهدة الإعلان
  void _continueViaRewardedAd() {
    _adManager.showRewarded((reward) {
      // مكافأة اللاعب: إخفاء القائمة وإرجاع سرعة اللاعب ليكمل طريقه
      setState(() {
        _isGameOver = false;
      });
      _game.player.position.x -= 30; // إرجاعه قليلاً للخلف لمنحه فرصة للاستعداد
      _game.player.speed = 150.0 + (_currentLevel * 15); // زيادة السرعة تدريجياً حسب المرحلة
    }, () {});
  }

  // الانتقال للمرحلة التالية مع إعلان بيني
  void _goToNextLevel() {
    _adManager.showInterstitial(() {
      setState(() {
        _isLevelComplete = false;
        _currentLevel++;
      });
      // زيادة صعوبة اللعبة بتسريع اللاعب تلقائياً في المرحلة الجديدة
      _game.startLevel();
      _game.player.speed = 150.0 + (_currentLevel * 15);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // عرض محرك اللعبة ثنائي الأبعاد
          GameWidget(game: _game),

          // عرض رقم المرحلة الحالية أعلى الشاشة بشكل مضيء
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              'LEVEL: $_currentLevel',
              style: const TextStyle(
                color: Color(0xff00ffcc),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),

          // 1. لوحة الخسارة المنبثقة (Game Over Overlay)
          if (_isGameOver)
            Container(
              color: Colors.black.withOpacity(0.85),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'PATH BLOCKED',
                      style: TextStyle(color: Color(0xffff007f), fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: 4),
                    ),
                    const SizedBox(height: 30),
                    
                    // الزر الأول: مشاهدة إعلان للمتابعة دون خسارة التقدم
                    _buildOverlayButton(
                      text: 'WATCH AD TO CONTINUE',
                      icon: Icons.movie_creation_outlined,
                      color: const Color(0xff00ffcc),
                      onPressed: _continueViaRewardedAd,
                    ),
                    const SizedBox(height: 15),
                    
                    // الزر الثاني: إعادة من نقطة البداية
                    _buildOverlayButton(
                      text: 'RESTART LEVEL',
                      icon: Icons.refresh,
                      color: Colors.white,
                      onPressed: _restartFromStart,
                    ),
                  ],
                ),
              ),
            ),

          // 2. لوحة الفوز المنبثقة (Level Complete Overlay)
          if (_isLevelComplete)
            Container(
              color: Colors.black.withOpacity(0.85),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'PATH CLEARED!',
                      style: TextStyle(color: Color(0xff00ffcc), fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: 4),
                    ),
                    const SizedBox(height: 30),
                    _buildOverlayButton(
                      text: 'NEXT LEVEL',
                      icon: Icons.arrow_forward_ios,
                      color: const Color(0xffff007f),
                      onPressed: _goToNextLevel,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOverlayButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 320,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff121224),
          side: BorderSide(color: color, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        label: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
      ),
    );
  }
}
