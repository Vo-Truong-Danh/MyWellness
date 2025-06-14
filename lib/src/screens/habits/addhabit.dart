import 'package:flutter/material.dart';
import 'package:my_wellness/src/screens/habits/createdrinkwater.dart';
import 'package:my_wellness/src/screens/habits/createexercise.dart';
import 'package:my_wellness/src/widget/habitbutton.dart';

class AddHabitBottomSheet extends StatefulWidget {
  const AddHabitBottomSheet({super.key});

  @override
  State<AddHabitBottomSheet> createState() => _AddHabitBottomSheet();
}

class _AddHabitBottomSheet extends State<AddHabitBottomSheet> {
  @override
  Widget build(BuildContext contextAddHabit) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
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
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
              onPressed: () {
                Navigator.pop(contextAddHabit);
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      alignment: Alignment.bottomCenter,
                      backgroundColor: const Color.fromARGB(255, 236, 235, 235),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 10.0,
                        ),
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
                            HabitButton(
                              fileImage: "assets/images/water_glass.png",
                              title: "Drink Water",
                              backgroundColor: const Color.fromARGB(
                                255,
                                62,
                                176,
                                230,
                              ),
                              onPressed:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => CreateHabitDrinkWater(),
                                    ),
                                  ),
                            ),
                            HabitButton(
                              fileImage: "assets/images/exercise.png",
                              title: "Exercise",
                              backgroundColor: Color.fromARGB(
                                255,
                                255,
                                234,
                                148,
                              ),
                              onPressed:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateExercise(),
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color.fromARGB(255, 255, 234, 148),
                    ),
                    child: Image.asset(
                      'assets/images/icon_star.png',
                      width: 30.0,
                      height: 30.0,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    "New Habit",
                    style: TextStyle(fontSize: 15.0, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
