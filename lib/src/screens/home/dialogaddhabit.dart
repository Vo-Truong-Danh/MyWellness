import 'package:flutter/material.dart';
import 'package:my_wellness/src/screens/home/createhabitdrinkwater.dart';

class ButtonHabit extends StatelessWidget {
  final String fileImage;
  final String title;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  const ButtonHabit({
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
                            ButtonHabit(
                              fileImage: "assets/images/water_glass.png",
                              title: "Drink Water",
                              backgroundColor: const Color.fromARGB(
                                255,
                                99,
                                206,
                                255,
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
                            ButtonHabit(
                              fileImage: "assets/images/icon_star.png",
                              title: "New Habit",
                              backgroundColor: Color.fromARGB(
                                255,
                                255,
                                234,
                                148,
                              ),
                            ),
                            ButtonHabit(
                              fileImage: "assets/images/icon_star.png",
                              title: "New Habit",
                              backgroundColor: Color.fromARGB(
                                255,
                                255,
                                234,
                                148,
                              ),
                            ),
                            ButtonHabit(
                              fileImage: "assets/images/icon_star.png",
                              title: "New Habit",
                              backgroundColor: Color.fromARGB(
                                255,
                                255,
                                234,
                                148,
                              ),
                            ),
                            ButtonHabit(
                              fileImage: "assets/images/icon_star.png",
                              title: "New Habit",
                              backgroundColor: Color.fromARGB(
                                255,
                                255,
                                234,
                                148,
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
