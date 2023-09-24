import 'package:fast_food_qr_ordering/bag_provider.dart';
import 'package:fast_food_qr_ordering/extras_provider.dart';
import 'package:fast_food_qr_ordering/pages/order_code.dart';
import 'package:fast_food_qr_ordering/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:fast_food_qr_ordering/storage.dart';
import 'package:uuid/uuid.dart';

class CustomerOrderSummary extends StatefulWidget {
  const CustomerOrderSummary({Key? key}) : super(key: key);

  @override
  State<CustomerOrderSummary> createState() => _CustomerOrderSummaryState();
}

class _CustomerOrderSummaryState extends State<CustomerOrderSummary> {
  final storage = OrderStorage();
  @override
  Widget build(BuildContext context) {
    final extrasProvider = Provider.of<ExtrasProvider>(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
      child: Consumer<BagProvider>(
          builder: (BuildContext context, BagProvider provider, Widget? child) {
        if (provider.bag.isEmpty) {
          return Container();
        } else {
          final ValueNotifier<double?> subtotal = ValueNotifier(null);
          int itemCount = 0;
          List items = [];
          for (int i = 0; i < provider.bag.length; i++) {
            itemCount += provider.bag[i].quantity!.value;
            items.add(provider.bag[i].toMap());
            subtotal.value =
                (provider.bag[i].price! * provider.bag[i].quantity!.value) +
                    (subtotal.value ?? 0);
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ValueListenableBuilder<double?>(
              valueListenable: subtotal,
              builder: (context, val, child) {
                var uuid = const Uuid();
                var orderID = uuid.v1();
                double totalPrice = double.parse(val!.toStringAsFixed(2));
                // final orderJSON = json.encode(orderMap);
                const californiaTaxes = 0.0884;
                final estimatedTaxes =
                    val != null ? (val * californiaTaxes) : 0;
                final total = val != null ? val + estimatedTaxes : 0;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Summary",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Subtotal"),
                          Text("\$${val?.toStringAsFixed(2) ?? 0}"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Estimated Tax"),
                          Text("\$${estimatedTaxes.toStringAsFixed(2)}"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("\$${total.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          extrasProvider.resetShowExtras();
                          storage.addOrder(orderID, json.encode(items),
                              itemCount, totalPrice);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderCode(orderID: orderID.toString()),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Finalize Order")),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
      }),
    );
  }
}
