import 'package:flutter/material.dart';
import 'package:my_wellness/src/core/recipe/identify_3_colors.dart';
import 'package:my_wellness/src/screens/habits/addhabit.dart';
import 'package:my_wellness/src/widget/habitcountcheck.dart';
import 'package:my_wellness/src/widget/habittaskcheck.dart';
import '../../core/recipe/showdialoghomepage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return Homepage();
  }
}

class Homepage extends State<HomePage> {
  static double Hr = 119; // Giá trị HR hiện tại
  final DateTime today = DateTime.now();
  Color ColorHr = identify_3_colors_exception(
    Hr,
    [60, 100],
    [50, 59],
    [20, 49],
    [120, 200],
    Colors.red,
    Colors.orange,
  );

  static double Weight = 69; // Giá trị Weight hiện tại

  static double MucTieuKcal = 1500;
  static double Kcal = 720; // Giá trị Kcal hiện tại

  Color ColorKcal = identify_3_colors(
    Kcal,
    [MucTieuKcal * 0.75, MucTieuKcal],
    [MucTieuKcal * 0.35, MucTieuKcal * 0.75],
    [0, MucTieuKcal * 0.35],
  );

  static double DailyGoal = 0.18; // % Hoàn thành các hoạt động hiện tại
  Color ColorDailyGoal = identify_3_colors(DailyGoal, [0.75, 1], [0.35, 0.74], [
    0,
    0.34,
  ]);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Showdialoghomepage(context, ColorHr, Hr);
      }
    });
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildStepsCard()),
                SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildSmallInfoCard(
                        icon: Icons.favorite,
                        iconColor: Colors.redAccent,
                        label: ' HR',
                        value: Text(
                          '${Hr.toInt()} bpm',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ColorHr,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildSmallInfoCard(
                        iconColor: Colors.blueAccent,
                        icon: Icons.bloodtype,
                        label: ' BP',
                        value: Text(
                          '120/80',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildSmallInfoCard(
                        icon: Icons.local_fire_department,
                        iconColor: Colors.orangeAccent,
                        label: 'Kcal',
                        value: Text(
                          '${Kcal.toInt()}',
                          style: TextStyle(
                            color: ColorKcal,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildSportsCard(),

            Center(
              heightFactor: 2.0,
              child: Divider(
                color: const Color.fromARGB(255, 209, 209, 209),
                thickness: 2,
              ),
            ),
            _buildWeekDaySelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekDaySelector() {
    final startOfWeek = today.subtract(Duration(days: today.weekday % 7));
    final List<DateTime> weekDates = List.generate(
      7,
      (i) => startOfWeek.add(Duration(days: i)),
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Tháng hiện tại
            TextButton(
              onPressed: () {},
              child: Text(
                "Tháng ${today.month}",
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
            // Today
            TextButton(
              onPressed: () {},
              child: Text(
                "Today",
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              weekDates.map((date) {
                bool isToday = _isSameDay(date, today);

                return Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          isToday ? Colors.white : Colors.transparent,
                    ),
                    onPressed: () {},
                    child: Column(
                      children: [
                        Text(
                          _getWeekdayLabel(date.weekday),
                          style: TextStyle(
                            fontWeight:
                                isToday ? FontWeight.bold : FontWeight.normal,
                            color: isToday ? Colors.black : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
        SizedBox(height: 10.0),
        HabitCountCheck(
          fileImage: "assets/images/water_glass.png",
          title: "Drink Water",
          backgroundIconColor: Color.fromARGB(255, 87, 197, 248),
        ),
        SizedBox(height: 10.0),
        HabitTaskCheck(
          fileImage: "assets/images/exercise.png",
          title: "Exercise",
          backgroundIconColor: Color.fromARGB(255, 219, 189, 70),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getWeekdayLabel(int weekday) {
    const labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return labels[weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF30C9B7),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu, size: 30, color: Colors.white),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Health Data",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 21,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Showdialoghomepage(context, ColorHr, Hr);
            },
            icon: Icon(Icons.update),
            iconSize: 30,
            color: Colors.white,
            tooltip: 'Cập nhật thể trạng hiện tại',
          ),
        ],
        toolbarHeight: 60,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            useSafeArea: true,
            context: context,
            builder: (context) {
              return AddHabitBottomSheet();
            },
          );
        },
        backgroundColor: Color(0xFF30C9B7),
        tooltip: 'Thêm mới',
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  Widget _buildStepsCard() {
    // tiến trình (0.0 đến 1.0)
    double currentProgress = DailyGoal;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Color(0xFF30C9B7),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.track_changes, color: Colors.white, size: 29),
              SizedBox(width: 8),
              Text(
                'DailyGoal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 130,
              height: 130,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 8,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.3),
                    ),
                  ),
                  CircularProgressIndicator(
                    value: currentProgress,
                    strokeWidth: 8,
                    valueColor: AlwaysStoppedAnimation<Color>(ColorDailyGoal),
                    backgroundColor: Colors.transparent,
                  ),
                  Center(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.8),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${(DailyGoal * 100).toInt()}%', // % hoàn thành mục tiêu hằng ngày
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 29),
        ],
      ),
    );
  }

  Widget _buildSmallInfoCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required Text value,
    VoidCallback? onTap, // Thêm tham số onTap
  }) {
    return InkWell(
      // Bọc bằng InkWell để có hiệu ứng gợn sóng và xử lý onTap
      onTap: onTap, // Gán callback
      borderRadius: BorderRadius.circular(
        15.0,
      ), // Để hiệu ứng gợn sóng khớp với bo góc của Container
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          // ... (Nội dung còn lại của Row giữ nguyên)
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Expanded(child: value),
          ],
        ),
      ),
    );
  }

  Widget _buildSportsCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF30C9B7).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.fitness_center,
              color: Color(0xFF30C9B7),
              size: 28,
            ), // Icon tạ
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '--km',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Thể thao',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}
