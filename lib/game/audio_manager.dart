import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  // تهيئة الأصوات مسبقاً في الذاكرة لمنع أي تأخير أثناء اللعب
  static Future<void> init() async {
    FlameAudio.bgm.initialize();
    // تحميل الملفات الصوتية في الكاش (تأكد من وضع ملفات wav أو mp3 قصيرة في assets/audio/)
    await FlameAudio.audioCache.loadAll([
      'tap_sound.mp3',
      'explosion.mp3',
      'level_win.mp3',
      'game_over.mp3'
    ]);
  }

  static void playTap() => FlameAudio.play('tap_sound.mp3', volume: 0.6);
  static void playExplosion() => FlameAudio.play('explosion.mp3', volume: 0.7);
  static void playWin() => FlameAudio.play('level_win.mp3', volume: 0.8);
  static void playGameOver() => FlameAudio.play('game_over.mp3', volume: 0.8);
}
