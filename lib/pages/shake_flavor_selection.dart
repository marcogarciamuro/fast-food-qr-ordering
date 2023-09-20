import 'package:fast_food_qr_ordering/pages/cancel_save_buttons.dart';
import 'package:fast_food_qr_ordering/pages/shake_option_tile.dart';
import 'package:fast_food_qr_ordering/shake_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShakeFlavorSelection extends StatefulWidget {
  const ShakeFlavorSelection({Key? key}) : super(key: key);

  @override
  State<ShakeFlavorSelection> createState() => _ShakeFlavorSelectionState();
}

class _ShakeFlavorSelectionState extends State<ShakeFlavorSelection> {
  @override
  Widget build(BuildContext context) {
    List<Map> shakes = [
      {"name": "Vanilla", "imagePath": "pictures/vanilla_shake.png"},
      {"name": "Strawberry", "imagePath": "pictures/strawberry_shake.png"},
      {"name": "Chocolate", "imagePath": "pictures/chocolate_shake.png"}
    ];
    final shakeProvider = Provider.of<ShakeProvider>(context);
    Future<bool> onWillPop() async {
      bool? shouldPop;
      if (shakeProvider.changesWereMade() == false) {
        shouldPop = true;
      } else {
        shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Center(child: Text('Are you sure?')),
              content: const Text(
                  "If you cancel now, all of your customization will be lost"),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
      }
      if (shouldPop!) {
        shakeProvider.discardCurrentFlavors();
      }
      return shouldPop;
    }

    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text("Select Flavor(s)",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: shakes.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ShakeOptionTile(
                      value: index,
                      groupValues: shakeProvider.currentSelectedFlavorsIndices,
                      imagePath: shakes[index]['imagePath'],
                      onChanged: () {
                        shakeProvider
                            .updateCurrentSelectedFlavorsIndices(index);
                      },
                      title: shakes[index]['name']);
                },
                separatorBuilder: (_, index) {
                  return const Divider(thickness: 1);
                },
              ),
            ),
            CancelSaveButtons(
              onWillPop: () => onWillPop(),
              onSave: () => shakeProvider.updateSavedIndices(),
            )
          ],
        ),
      ),
    );
  }
}
