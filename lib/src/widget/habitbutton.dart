import 'package:flutter/material.dart';

class HabitButton extends StatelessWidget {
  final String fileImage;
  final String title;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  const HabitButton({
    super.key,
    required this.fileImage,
    required this.title,
    this.backgroundColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
      onPressed: onPressed ?? () {},
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: backgroundColor,
            ),
            child: Image.asset(fileImage, width: 30.0, height: 30.0),
          ),
          SizedBox(width: 20.0),
          Text(title, style: TextStyle(fontSize: 15.0, color: Colors.black)),
        ],
      ),
    );
  }
}
