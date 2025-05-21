import 'package:flutter/material.dart';

class CreateHabitDrinkWater extends StatefulWidget {
  const CreateHabitDrinkWater({super.key});

  @override
  State<CreateHabitDrinkWater> createState() => _CreateHabitDrinkWaterState();
}

class _CreateHabitDrinkWaterState extends State<CreateHabitDrinkWater> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close),
        ),
        title: Text(
          "Create",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
    );
  }
}
