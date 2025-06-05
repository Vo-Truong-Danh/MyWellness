import 'package:flutter/material.dart';

class TextFormFieldMyWidget extends StatelessWidget {
  final String? initialValue;
  final TextAlign textAlign;
  const TextFormFieldMyWidget({
    super.key,
    required this.initialValue,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 214, 214, 214),
            blurRadius: 10.0,
            spreadRadius: 0.5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: TextFormField(
        textAlign: textAlign,
        style: TextStyle(fontSize: 20.0),
        initialValue: initialValue,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        ),
      ),
    );
  }
}
