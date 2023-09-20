import 'package:fast_food_qr_ordering/shake_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerticalSizeSelector extends StatefulWidget {
  const VerticalSizeSelector({Key? key}) : super(key: key);

  @override
  State<VerticalSizeSelector> createState() => _VerticalSizeSelectorState();
}

class _VerticalSizeSelectorState extends State<VerticalSizeSelector> {
  @override
  Widget build(BuildContext context) {
    final shakeProvider = Provider.of<ShakeProvider>(context);
    List sizes = [
      {"text": "Small", "label": "S"},
      {"text": "Medium", "label": "M"},
      {"text": "Large", "label": "L"}
    ];
    return ListView.separated(
      shrinkWrap: true,
      itemCount: sizes.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        bool isSelected = index == shakeProvider.currentSizeIndex;
        return InkWell(
          onTap: () {
            print("HI");
            shakeProvider.currentSizeIndex = index;
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Text(sizes[index]['label']))),
                  const SizedBox(width: 10),
                  Text(sizes[index]['text'],
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
              isSelected
                  ? const Icon(Icons.check_circle_rounded,
                      color: Color(0xFFE02A27))
                  : Container(),
            ],
          ),
        );
      },
      separatorBuilder: (_, index) {
        return const SizedBox(height: 20);
      },
    );
  }
}
