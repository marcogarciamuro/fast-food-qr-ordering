import 'package:flutter/material.dart';

class CancelSaveButtons extends StatelessWidget {
  const CancelSaveButtons(
      {Key? key, required this.onWillPop, required this.onSave})
      : super(key: key);
  final onWillPop;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: const Center(
                  child: Text("Cancel",
                      style: TextStyle(color: Color(0xFFE02A27)))),
            ),
          ),
        ),
        Flexible(
          child: GestureDetector(
            onTap: () {
              onSave();
              if (context.mounted) {
                Navigator.pop(context);
              }
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
    );
  }
}
