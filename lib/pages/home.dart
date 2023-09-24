import 'package:flutter/material.dart';
import 'package:fast_food_qr_ordering/pages/scan_code.dart';
import 'package:fast_food_qr_ordering/storage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final storage = OrderStorage();
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).orientation);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                Image.asset("./pictures/Up-n-Atom.png"),
                const SizedBox(height: 30),
                const Text(
                  'Quality you can taste',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Courgette',
                    fontSize: 30,
                    // fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 70),
                SizedBox(
                  height: 50,
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE02A27),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/menu');
                    },
                    child: const Text("Customer",
                        style:
                            TextStyle(fontSize: 20, fontFamily: 'Courgette')),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE02A27),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScanCode()),
                      );
                    },
                    child: const Text("Employee",
                        style:
                            TextStyle(fontSize: 20, fontFamily: "Courgette")),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
