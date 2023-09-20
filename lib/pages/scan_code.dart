import 'dart:convert';
import 'package:fast_food_qr_ordering/worker_bag_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:fast_food_qr_ordering/pages/review_order.dart';
import 'dart:developer';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:fast_food_qr_ordering/bag_model.dart';
import 'package:fast_food_qr_ordering/bag_provider.dart';
import 'package:fast_food_qr_ordering/db_helper.dart';
import 'package:provider/provider.dart';

class ScanCode extends StatefulWidget {
  const ScanCode({Key? key}) : super(key: key);

  @override
  State<ScanCode> createState() => _ScanCodeState();
}

class _ScanCodeState extends State<ScanCode> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            title:
                Text("Scan Order Code", style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.black)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // const Text("Scan Order Code",
              //     textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
              Expanded(flex: 3, child: _buildQrView(context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller?.pauseCamera();
                      },
                      child:
                          const Text('pause', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller?.resumeCamera();
                      },
                      child:
                          const Text('resume', style: TextStyle(fontSize: 20)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 400.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      if (result?.code != null) {
        await controller.pauseCamera();
        final Map order = jsonDecode(result?.code ?? "");
        var uuid = const Uuid();
        print("order: $order");
        order['items'].forEach((itemMap) {
          print("ITEM FOUND");
          itemMap['uniqueID'] = uuid.v1();
          saveData(itemMap);
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewOrder(),
          ),
        );
      }
    });
  }

  void saveData(Map bagInfo) {
    DBHelper dbHelper = DBHelper();
    final bag = Provider.of<WorkerBagProvider>(context, listen: false);
    dbHelper.addWorkerBagToDB(Bag.fromMap(bagInfo)).then((value) {
      bag.addToTotalPrice(bagInfo['price']);
      bag.addCounter();
      print("Item added to bag");
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("NO Permission")));
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
