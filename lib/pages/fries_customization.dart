import 'package:fast_food_qr_ordering/fries_provider.dart';
import 'package:fast_food_qr_ordering/pages/custom_expansion_tile.dart';
import 'package:fast_food_qr_ordering/pages/selectable_option_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomizeFries extends StatefulWidget {
  const CustomizeFries({Key? key}) : super(key: key);

  @override
  State<CustomizeFries> createState() => _CustomizeFriesState();
}

bool specialRequestMade = false;

class _CustomizeFriesState extends State<CustomizeFries> {
  @override
  Widget build(BuildContext context) {
    final fryProvider = Provider.of<FryProvider>(context);

    Future<bool> _onWillPop() async {
      bool? shouldPop;
      if (fryProvider.changesWereMade() == false) {
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
        fryProvider.discardCurrentSelectedOptions();
      }
      return shouldPop;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text("Customize Fries",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView(children: [
                  Card(
                    elevation: 0.0,
                    child: Column(
                      children: [
                        CustomExpansionTile(
                          menuLabel: "Wellness",
                          options: const [
                            "Light",
                            "Normal",
                            "Well Done",
                            "Extra Well Done"
                          ],
                          imagePath: "pictures/fries.png",
                          defaultIndex: fryProvider.defaultWellnessIndex,
                          currentIndex: fryProvider.currentWellnessIndex,
                          updateCurrentIndex: (val) {
                            fryProvider.setCurrentIndex("Wellness", val);
                          },
                        ),
                        CustomExpansionTile(
                          menuLabel: "Salt",
                          options: const [
                            "None",
                            "Light Salt",
                            "Normal",
                            "Extra Salt"
                          ],
                          imagePath: "pictures/fries.png",
                          defaultIndex: fryProvider.defaultSaltIndex,
                          currentIndex: fryProvider.currentSaltIndex,
                          updateCurrentIndex: (val) {
                            fryProvider.setCurrentIndex("Salt", val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Special Request",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        specialRequestMade
                            ? GestureDetector(
                                onTap: () {
                                  fryProvider.setCurrentIndex("Style", -1);
                                  setState(() {
                                    specialRequestMade = false;
                                  });
                                },
                                child: const Text("Clear Selection",
                                    style: TextStyle(color: Colors.blue)),
                              )
                            : Container()
                      ],
                    ),
                  ),
                  Card(
                    elevation: 0.0,
                    margin: EdgeInsets.zero,
                    child: SelectableOptionTile(
                      value: 0,
                      groupValue: fryProvider.currentStyleIndex,
                      title: "Animal Style",
                      onChanged: (value) {
                        fryProvider.setCurrentIndex("Style", 0);
                        setState(() {
                          specialRequestMade = true;
                        });
                      },
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 0.0,
                    child: SelectableOptionTile(
                      value: 1,
                      groupValue: fryProvider.currentStyleIndex,
                      title: "Cheese Fries",
                      onChanged: (value) {
                        fryProvider.setCurrentIndex("Style", 1);
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
                        if (await _onWillPop()) {
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: const Center(
                            child: Text("Cancel",
                                style: TextStyle(color: Color(0xFFE02A27)))),
                      ),
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        fryProvider.updateSavedIndices();
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
          )),
    );
  }
}
