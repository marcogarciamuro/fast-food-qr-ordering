import 'package:fast_food_qr_ordering/pages/custom_expansion_tile.dart';
import 'package:fast_food_qr_ordering/pages/selectable_option_tile.dart';
import 'package:fast_food_qr_ordering/burger_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BurgerCustomization extends StatefulWidget {
  const BurgerCustomization({Key? key}) : super(key: key);

  @override
  State<BurgerCustomization> createState() => _BurgerCustomizationState();
}

List burgerOptions = [
  {
    "optionTitle": "Bun",
    "imagePath": "pictures/buns.jpg",
    "options": ['Untoasted', 'Toasted', 'Extra Toasted'],
  },
  {
    "optionTitle": "Lettuce",
    "imagePath": "pictures/lettuce.png",
    "options": ['None', 'Normal', 'Extra'],
  },
  {
    "optionTitle": "Onion",
    "imagePath": "pictures/onion_slices.png",
    "options": ['None', 'Normal', 'Grilled', 'Extra'],
  },
  {
    "optionTitle": "Tomato",
    "imagePath": "pictures/tomato.png",
    "options": ['None', 'Normal', 'Extra'],
  },
  {
    "optionTitle": "Sauce",
    "imagePath": "pictures/burger_sauce.png",
    "options": [
      'None',
      'Spread',
      'Extra Spread',
      'Ketchup',
      'Mustard',
      'Ketchup & Mustard'
    ],
  },
];

bool specialRequestMade = false;

class _BurgerCustomizationState extends State<BurgerCustomization> {
  @override
  Widget build(BuildContext context) {
    final burgerProvider = Provider.of<BurgerProvider>(context);

    Future<bool> onWillPop() async {
      bool? shouldPop;
      if (burgerProvider.changesWereMade() == false) {
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
        burgerProvider.discardCurrentSelectedOptions();
      }
      return shouldPop;
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text("Customize Burger",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(children: <Widget>[
                Card(
                  elevation: 0.0,
                  child: ListView.separated(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: burgerOptions.length,
                    itemBuilder: (context, index) {
                      String title =
                          burgerOptions[index]['optionTitle'] as String;
                      List<String> options =
                          burgerOptions[index]['options'] as List<String>;
                      String imagePath =
                          burgerOptions[index]['imagePath'] as String;
                      return (CustomExpansionTile(
                          menuLabel: title,
                          options: options,
                          imagePath: imagePath,
                          defaultIndex: burgerProvider.getDefaultIndex(title),
                          currentIndex: burgerProvider.getCurrentIndex(title),
                          updateCurrentIndex: (val) {
                            burgerProvider.setCurrentIndex(title, val);
                          }));
                    },
                    separatorBuilder: (_, index) {
                      return const Divider(thickness: 1);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Special Request",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      specialRequestMade
                          ? GestureDetector(
                              onTap: () {
                                if (burgerProvider.currentStyleIndex == 1) {
                                  burgerProvider.undoBurgerPlain();
                                }
                                burgerProvider.setCurrentIndex('Style', -1);
                                setState(() {
                                  specialRequestMade = false;
                                });
                              },
                              child: const Text('Clear Selection',
                                  style: TextStyle(color: Colors.blue)))
                          : Container()
                    ],
                  ),
                ),
                Card(
                  elevation: 0.0,
                  margin: EdgeInsets.zero,
                  child: SelectableOptionTile(
                    value: 0,
                    groupValue: burgerProvider.currentStyleIndex,
                    title: "Animal Style",
                    onChanged: (value) {
                      if (burgerProvider.currentStyleIndex == 1) {
                        burgerProvider.undoBurgerPlain();
                      }
                      burgerProvider.setCurrentIndex("Style", 0);
                      setState(() {
                        specialRequestMade = true;
                      });
                    },
                  ),
                ),
                Card(
                  elevation: 0.0,
                  margin: EdgeInsets.zero,
                  child: SelectableOptionTile(
                    value: 1,
                    groupValue: burgerProvider.currentStyleIndex,
                    title: "Plain",
                    onChanged: (value) {
                      if (burgerProvider.currentStyleIndex == 1) {
                        burgerProvider.undoBurgerPlain();
                      }
                      burgerProvider.setCurrentIndex("Style", 1);
                      burgerProvider.makeBurgerPlain();
                      setState(() {
                        specialRequestMade = true;
                      });
                    },
                  ),
                ),
                Card(
                  elevation: 0.0,
                  margin: EdgeInsets.zero,
                  child: SelectableOptionTile(
                    value: 2,
                    groupValue: burgerProvider.currentStyleIndex,
                    title: "Protein Style",
                    onChanged: (value) {
                      burgerProvider.setCurrentIndex("Style", 2);
                      setState(() {
                        specialRequestMade = true;
                      });
                    },
                  ),
                ),
              ]),
            ),
            Row(
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () async {
                      if (await onWillPop()) {
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: const Center(
                          child: Text("Cancel",
                              style: TextStyle(color: Color(0xFFE02A27)))),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      burgerProvider.updateSavedIndices();
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Color(0xFFFFCB05),
                          border: Border(
                            top: BorderSide(color: Colors.grey),
                          )),
                      child: const Center(child: Text("Save Changes")),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
