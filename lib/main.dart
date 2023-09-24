import 'package:fast_food_qr_ordering/extras_provider.dart';
import 'package:fast_food_qr_ordering/fries_provider.dart';
import 'package:fast_food_qr_ordering/drink_provider.dart';
import 'package:fast_food_qr_ordering/meal_provider.dart';
import 'package:fast_food_qr_ordering/user_provider.dart';
import 'package:fast_food_qr_ordering/worker_bag_provider.dart';
import 'package:fast_food_qr_ordering/shake_provider.dart';
import 'package:fast_food_qr_ordering/burger_provider.dart';
import 'package:flutter/material.dart';
import 'package:fast_food_qr_ordering/pages/home.dart';
import 'package:fast_food_qr_ordering/bag_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:fast_food_qr_ordering/pages/menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BagProvider()),
          ChangeNotifierProvider(create: (_) => WorkerBagProvider()),
          ChangeNotifierProvider(create: (_) => BurgerProvider()),
          ChangeNotifierProvider(create: (_) => FryProvider()),
          ChangeNotifierProvider(create: (_) => DrinkProvider()),
          ChangeNotifierProvider(create: (_) => ShakeProvider()),
          ChangeNotifierProvider(create: (_) => MealProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => ExtrasProvider()),
        ],
        child: Builder(builder: (BuildContext context) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const Home(),
              routes: <String, WidgetBuilder>{
                '/menu': (BuildContext context) => const Menu(),
              });
        })),
  );
}
