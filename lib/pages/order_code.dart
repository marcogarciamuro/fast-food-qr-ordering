import 'package:fast_food_qr_ordering/db_helper.dart';
import 'package:fast_food_qr_ordering/extras_provider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class OrderCode extends StatefulWidget {
  const OrderCode({Key? key, required this.orderID}) : super(key: key);
  final String orderID;

  @override
  State<OrderCode> createState() => _OrderCodeState();
}

class _OrderCodeState extends State<OrderCode> {
  final GlobalKey _globalKey = GlobalKey();
  DBHelper? dbHelper = DBHelper();

  Future<void> _saveQrCode() async {
    try {
      final RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      //create file
      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String fullPath = '$dir/${DateTime.now().millisecond}.png';
      File capturedFile = File(fullPath);
      await capturedFile.writeAsBytes(pngBytes);

      await GallerySaver.saveImage(capturedFile.path).then((value) {
        print("saved to gallery");
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final extrasProvider = Provider.of<ExtrasProvider>(context);
    Future<bool> onWillPop() async {
      extrasProvider.resetShowExtras();
      dbHelper!.deleteAllCustomerBagItems();
      Navigator.pop(context);
      Navigator.pop(context);
      return true;
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () async {
              await onWillPop();
            },
            icon: const Icon(Icons.close),
            splashRadius: 1.0,
          ),
        ),
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: Column(
              children: [
                const Text(
                  "Order Complete",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                const SizedBox(height: 10),
                const Text("Show this code at restaurant to place your order",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20)),
                const SizedBox(height: 15),
                RepaintBoundary(
                  key: _globalKey,
                  child: QrImage(data: widget.orderID, size: 300),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 180,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE02A27)),
                    onPressed: () async {
                      await _saveQrCode();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Downloaded to Gallery!'),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Save to Gallery",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // const Text(
                //   "We appreciate your support. Enjoy your meal!",
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontWeight: FontWeight.w500,
                //     // fontFamily: 'Courgette',
                //     fontStyle: FontStyle.italic,
                //     fontSize: 20,
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
