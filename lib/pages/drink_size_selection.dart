import 'package:fast_food_qr_ordering/drink_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SizeSelector extends StatefulWidget {
  const SizeSelector(
      {Key? key, required this.selectedIndex, required this.onChanged})
      : super(key: key);

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  @override
  Widget build(BuildContext context) {
    final drinkProvider = Provider.of<DrinkProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            widget.onChanged(0);
          },
          child: Column(
            children: [
              Material(
                elevation: 5,
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: widget.selectedIndex == 0
                        ? Border.all(width: 3, color: Colors.red)
                        : null,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: Text("S",
                          style: TextStyle(
                              fontSize: widget.selectedIndex == 0 ? 18 : 15,
                              fontWeight: widget.selectedIndex == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal))),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Small",
                style: TextStyle(
                    fontWeight: widget.selectedIndex == 0
                        ? FontWeight.bold
                        : FontWeight.normal),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            widget.onChanged(1);
          },
          child: Column(
            children: [
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: widget.selectedIndex == 1
                        ? Border.all(width: 3, color: Colors.red)
                        : null,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: Text("M",
                          style: TextStyle(
                              fontSize: widget.selectedIndex == 1 ? 18 : 15,
                              fontWeight: widget.selectedIndex == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal))),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Medium",
                style: TextStyle(
                    fontWeight: widget.selectedIndex == 1
                        ? FontWeight.bold
                        : FontWeight.normal),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            widget.onChanged(2);
          },
          child: Column(
            children: [
              Material(
                borderRadius: BorderRadius.circular(100),
                elevation: 5.0,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: widget.selectedIndex == 2
                        ? Border.all(width: 3, color: Colors.red)
                        : null,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: Text("L",
                          style: TextStyle(
                              fontSize: widget.selectedIndex == 2 ? 18 : 15,
                              fontWeight: widget.selectedIndex == 2
                                  ? FontWeight.bold
                                  : FontWeight.normal))),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Large",
                style: TextStyle(
                    fontWeight: widget.selectedIndex == 2
                        ? FontWeight.bold
                        : FontWeight.normal),
              )
            ],
          ),
        ),
      ],
    );
  }
}
