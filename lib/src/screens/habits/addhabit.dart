import 'package:flutter/material.dart';
import 'package:my_wellness/src/screens/habits/createdrinkwater.dart';
import 'package:my_wellness/src/screens/habits/createexercise.dart';
import 'package:my_wellness/src/widget/habitbutton.dart';

class AddHabitDialog extends StatefulWidget {
  const AddHabitDialog({super.key});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialog();
}

class _AddHabitDialog extends State<AddHabitDialog> {
  @override
  Widget build(BuildContext contextAddHabit) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      backgroundColor: const Color.fromARGB(255, 236, 235, 235),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          spacing: 20.0,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
                Expanded(
                  child: Text(
                    "Thêm",
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
            HabitButton(
              fileImage: "assets/images/water_glass.png",
              title: "Uống nước",
              backgroundColor: const Color.fromARGB(255, 62, 176, 230),
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateHabitDrinkWater(),
                    ),
                  ),
            ),
            HabitButton(
              fileImage: "assets/images/exercise.png",
              title: "Tập thể dục",
              backgroundColor: Color.fromARGB(255, 255, 234, 148),
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateExercise()),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
