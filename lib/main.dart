import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/main_menu.dart';

void main() async {
  // التأكد من تهيئة كل خدمات Flutter قبل تشغيل اللعبة
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة إعلانات Google AdMob
  unawaited(MobileAds.instance.initialize());

  // جعل اللعبة تعمل بالوضع الأفقي فقط وتغطية الشاشة بالكامل
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(const OpenThePathApp());
}

// المساعد لتجنب مشاكل الـ unawaited مع الأكواد غير المتزامنة
void unawaited(Future<void> future) {}

class OpenThePathApp extends StatelessWidget {
  const OpenThePathApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open The Path',
      debugShowCheckedModeBanner: false,
      // ثيم سيبراني مظلم مع لمسات نيون فسفورية ممتعة للعين
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff0a0a12),
        primaryColor: const Color(0xff00ffcc), // لون النيون الأساسي
        fontFamily: 'Roboto', // يمكنك تخصيصه لاحقاً
      ),
      home: const MainMenuScreen(),
    );
  }
}
