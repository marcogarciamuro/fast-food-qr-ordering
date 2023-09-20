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

void main() {
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
        ],
        child: Builder(builder: (BuildContext context) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Home(),
          );
        })),
  );
}
