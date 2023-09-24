import 'package:fast_food_qr_ordering/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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

  Future<bool> _onWillPop() async {
    Navigator.popUntil(context, ModalRoute.withName('/menu'));
    dbHelper!.deleteAllCustomerBagItems();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () async {
              await _onWillPop();
            },
            icon: const Icon(Icons.close),
            splashRadius: 1.0,
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const Text(
                "Order Complete",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const Text("Show this code at restaurant to place order",
                  style: TextStyle(fontSize: 15)),
              const SizedBox(height: 15),
              RepaintBoundary(
                key: _globalKey,
                child: QrImage(data: widget.orderID, size: 300),
              ),
              ElevatedButton(
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
                child: const Text("Save to Gallery"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
