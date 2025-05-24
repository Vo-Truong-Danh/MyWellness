import 'package:flutter/material.dart';

class HabitCountCheck extends StatefulWidget {
  final String fileImage;
  final String title;
  final Color? backgroundIconColor;
  final VoidCallback? onPressedContainer;
  int _currentNumberOfGlasses;
  int _totalNumberOfGlasses;

  int get currentNumberOfGlasses => _currentNumberOfGlasses;

  set currentNumberOfGlasses(int value) {
    if (value >= 0 && value <= _totalNumberOfGlasses) {
      _currentNumberOfGlasses = value;
    }
  }

  int get totalNumberOfGlasses => _totalNumberOfGlasses;

  set totalNumberOfGlasses(int value) {
    if (value >= 0) {
      _totalNumberOfGlasses = value;
    }
  }

  HabitCountCheck({
    super.key,
    required this.fileImage,
    required this.title,
    this.backgroundIconColor,
    this.onPressedContainer,
    int currentNumberOfGlasses = 0,
    int totalNumberOfGlasses = 8,
  }) : _currentNumberOfGlasses = currentNumberOfGlasses,
       _totalNumberOfGlasses = totalNumberOfGlasses;

  @override
  State<HabitCountCheck> createState() => _HabitCountCheckState();
}

class _HabitCountCheckState extends State<HabitCountCheck> {
  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem đã hoàn thành chưa
    bool isCompleted =
        widget.currentNumberOfGlasses >= widget.totalNumberOfGlasses;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
      onPressed: widget.onPressedContainer ?? () {},
      child: Row(
        spacing: 15.0,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: widget.backgroundIconColor,
            ),
            child: Image.asset(widget.fileImage, width: 30.0, height: 30.0),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                ),
                Text(
                  "${widget.currentNumberOfGlasses}/${widget.totalNumberOfGlasses} glasses",
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed:
                isCompleted
                    ? null
                    : () {
                      setState(() {
                        if (widget.currentNumberOfGlasses <
                            widget.totalNumberOfGlasses) {
                          widget.currentNumberOfGlasses++;
                        }
                      });
                    },
            icon: Icon(
              isCompleted ? Icons.check_circle_outline : Icons.add,
              size: 30.0,
              color: isCompleted ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
