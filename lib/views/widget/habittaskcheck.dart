import 'package:flutter/material.dart';

class HabitTaskCheck extends StatefulWidget {
  final String fileImage;
  final String title;
  final Color? backgroundIconColor;
  final VoidCallback? onPressedContainer;

  const HabitTaskCheck({
    super.key,
    required this.fileImage,
    required this.title,
    this.backgroundIconColor,
    this.onPressedContainer,
  });

  @override
  State<HabitTaskCheck> createState() => _HabitTaskCheckState();
}

class _HabitTaskCheckState extends State<HabitTaskCheck> {
  bool _isCheck = false;
  bool get isCompleted => _isCheck;

  set isCompleted(bool value) {
    setState(() {
      _isCheck = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
      onPressed: widget.onPressedContainer ?? () {},
      child: Row(
        spacing: 10.0,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(5.0),
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
                  style: const TextStyle(fontSize: 15.0, color: Colors.black),
                ),
                Text(
                  "Task",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: _isCheck ? Colors.green : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isCheck = !_isCheck;
              });
            },
            icon: Icon(
              _isCheck ? Icons.check_circle_outline : Icons.circle_outlined,
              size: 30.0,
              color: _isCheck ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
