import 'package:flutter/material.dart';
import 'package:my_wellness/src/data/valuenotifier.dart';

class RepeatStyleButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  const RepeatStyleButton({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
      onPressed: onPressed ?? () {},
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 15.0, color: Colors.black),
        ),
      ),
    );
  }
}

class ChangeRepeatStyleBottomSheet extends StatefulWidget {
  const ChangeRepeatStyleBottomSheet({super.key});

  @override
  State<ChangeRepeatStyleBottomSheet> createState() =>
      _ChangeRepeatStyleBottomSheet();
}

class _ChangeRepeatStyleBottomSheet
    extends State<ChangeRepeatStyleBottomSheet> {
  @override
  Widget build(BuildContext contextAddHabit) {
    return ValueListenableBuilder(
      valueListenable: selectedRepeatNotifier,
      builder: (context, value, child) {
        return SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30.0,
              horizontal: 20.0,
            ),
            child: Column(
              spacing: 20.0,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                    ),
                    Expanded(
                      child: Text(
                        "Add",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 48.0),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedRepeatNotifier.value = 0;
                      print(value);
                      Navigator.pop(context);
                    });
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      "None",
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedRepeatNotifier.value = 1;
                      print(value);
                      Navigator.pop(context);
                    });
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Select Days",
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedRepeatNotifier.value = 2;
                      print(value);
                      Navigator.pop(context);
                    });
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Every few Days",
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
