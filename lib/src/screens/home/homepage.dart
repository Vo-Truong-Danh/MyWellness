import 'package:flutter/material.dart';
import 'package:my_wellness/src/core/recipe/identify_3_colors.dart';
import 'package:my_wellness/src/screens/habits/addhabit.dart';
import 'package:my_wellness/src/widget/habitcountcheck.dart';
import 'package:my_wellness/src/widget/habittaskcheck.dart';
import 'package:my_wellness/src/widget/health_metrics_dialog.dart';
import '../../core/recipe/showdialoghomepage.dart';
import 'package:provider/provider.dart';
import '../../data/providers/selected_date_provider.dart';
import '../../data/providers/health_data_provider.dart';
import '../../data/models/health_entries.dart';
import 'package:intl/intl.dart';

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

  // Giá trị cho theo dõi giấc ngủ
  static double SleepHours = 6.5; // Số giờ ngủ
  Color ColorSleep = identify_3_colors(SleepHours, [7, 9], [5, 6.9], [0, 4.9]);

  // Giá trị cho quản lý chế độ ăn uống
  static double DietGoal = 0.6; // Tiến độ hoàn thành chế độ ăn uống
  Color ColorDiet = identify_3_colors(DietGoal, [0.75, 1], [0.35, 0.74], [
    0,
    0.34,
  ]);

  @override
  void initState() {
    super.initState();

    // Tải dữ liệu người dùng và nhật ký sức khỏe khi màn hình khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final healthProvider = Provider.of<HealthDataProvider>(context, listen: false);
        final dateProvider = Provider.of<SelectedDateProvider>(context, listen: false);

        // Tải thông tin người dùng
        healthProvider.loadUserData();

        // Tải nhật ký sức khỏe của ngày hiện tại
        healthProvider.loadDailyLog(dateProvider.selectedDate);

        // Hiện dialog cập nhật thông tin sức khỏe (giữ nguyên chức năng cũ)
        Showdialoghomepage(context, ColorHr, Hr);
      }
    });
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

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWeekDaySelector(),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            _buildSleepCard(), // Thẻ theo dõi giấc ngủ
            SizedBox(height: 20),
            _buildDietCard(), // Thẻ quản lý chế độ ăn uống
            Center(
              heightFactor: 2.0,
              child: Divider(
                color: const Color.fromARGB(255, 209, 209, 209),
                thickness: 2,
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekDaySelector() {
    return Consumer<SelectedDateProvider>(
        builder: (context, dateProvider, child) {
          final selectedDate = dateProvider.selectedDate;

          // Tính toán ngày đầu tuần (chủ nhật) dựa vào ngày đang chọn
          final startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday % 7));
          final List<DateTime> weekDates = List.generate(
            7,
                (i) => startOfWeek.add(Duration(days: i)),
          );

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nút điều hướng qua tuần trước
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => dateProvider.previousWeek(),
                  ),

                  // Hiển thị tháng hiện tại
                  Text(
                    dateProvider.getFormattedMonth(),
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),

                  // Nút quay về ngày hôm nay
                  TextButton(
                    onPressed: () => dateProvider.setDate(DateTime.now()),
                    child: Text(
                      "Hôm nay",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor
                      ),
                    ),
                  ),

                  // Nút điều hướng qua tuần sau
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () => dateProvider.nextWeek(),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: weekDates.map((date) {
                  bool isSelected = _isSameDay(date, selectedDate);
                  bool isToday = _isSameDay(date, DateTime.now());

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => dateProvider.setDate(date),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: isSelected ? Color(0xFF30C9B7).withOpacity(0.2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: isToday && !isSelected ?
                          Border.all(color: Color(0xFF30C9B7)) : null,
                        ),
                        child: Column(
                          children: [
                            Text(
                              _getWeekdayLabel(date.weekday),
                              style: TextStyle(
                                fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? Color(0xFF30C9B7) :
                                isToday ? Colors.black : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${date.day}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Color(0xFF30C9B7) : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
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
    );
  }

  String _getWeekdayLabel(int weekday) {
    const labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return labels[weekday % 7];
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildStepsCard() {
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
                          '${(DailyGoal * 100).toInt()}%',
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
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.0),
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
            ),
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

  Widget _buildSleepCard() {
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
              color: Colors.purple.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              "assets/images/sleep.png",
              width: 28,
              height: 28,
              color: Colors.purple,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theo dõi giấc ngủ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
    );
  }

  Widget _buildDietCard() {
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
              color: Colors.green.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              "assets/images/diet.png",
              width: 28,
              height: 28,
              color: Colors.green,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chế độ ăn uống',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
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
