import 'package:fast_food_qr_ordering/pages/selectable_option_tile.dart';
import 'package:flutter/material.dart';

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({
    Key? key,
    required this.menuLabel,
    required this.defaultIndex,
    required this.currentIndex,
    required this.options,
    required this.imagePath,
    required this.updateCurrentIndex,
  }) : super(key: key);
  final String menuLabel;
  final List options;
  final String imagePath;
  final int defaultIndex;
  final int currentIndex;
  final ValueChanged<int> updateCurrentIndex;

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool expanded = false;
  bool optionSelected = false;
  @override
  void dispose() {
    super.dispose();
    expanded = false;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      optionSelected = widget.currentIndex != widget.defaultIndex;
    });
    int currentIndex = widget.currentIndex != -1 ? widget.currentIndex : 0;

    return GestureDetector(
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: Column(
        children: [
          InkWell(
            splashColor: Colors.green,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(color: Colors.white),
              height: 70,
              margin: const EdgeInsets.only(bottom: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(widget.imagePath, width: 50),
                      const SizedBox(width: 5),
                      Text(widget.menuLabel,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      // show the current Selected option next to the dropdown arrow
                      optionSelected
                          ? Text(widget.options[currentIndex])
                          : Container(),
                      Icon(expanded
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down),
                    ],
                  ),
                ],
              ),
            ),
          ),
          expanded
              ? Column(
                  children: [
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.options.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return SelectableOptionTile(
                          value: index,
                          groupValue: currentIndex,
                          title: widget.options[index],
                          onChanged: (value) {
                            // optionsProvider.setCurrentIndex(
                            //     widget.menuLabel, index);
                            setState(() {
                              optionSelected = true;
                              widget.updateCurrentIndex(index);
                              expanded = false;
                            });
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(thickness: 1),
                        );
                      },
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
