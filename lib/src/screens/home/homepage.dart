import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_wellness/src/data/providers/health_data_provider.dart';
import 'package:my_wellness/src/data/providers/selected_date_provider.dart';
import 'package:my_wellness/src/screens/nutrition_tracking/add_food_screen.dart';
import 'package:my_wellness/src/screens/workout_tracking/add_workout_screen.dart';
import 'package:my_wellness/src/widget/add_options_bottom_sheet.dart';
import 'package:my_wellness/src/widget/health_card_row.dart';
import 'package:my_wellness/src/widget/habitcountcheck.dart';
import 'package:my_wellness/src/widget/habittaskcheck.dart';

// Global key to access HomePage state
final GlobalKey<_HomePageV2State> homePageKey = GlobalKey<_HomePageV2State>();

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: homePageKey);

  static void refreshData() {
    if (homePageKey.currentState != null) {
      homePageKey.currentState!.refreshData();
    }
  }

  @override
  _HomePageV2State createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshData();
    });
  }

  void refreshData() {
    final healthProvider = Provider.of<HealthDataProvider>(context, listen: false);
    final dateProvider = Provider.of<SelectedDateProvider>(context, listen: false);
    healthProvider.loadUserData();
    healthProvider.loadDailyLog(dateProvider.selectedDate);
    setState(() {});
  }

  void _showUpdateHealthDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Cập nhật thể trạng'),
        content: Text('Tính năng cập nhật thể trạng sẽ sớm được thêm vào.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Đóng'))
        ],
      ),
    );
  }

  void _showAddOptionsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddOptionsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF30C9B7);
    final accentColor = Color(0xFF1E88E5);
    final backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, primaryColor.withOpacity(0.8)],
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Sức Khỏe Của Tôi',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.update, color: Colors.white),
            onPressed: _showUpdateHealthDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            refreshData();
            await Future.delayed(Duration(milliseconds: 500));
          },
          color: primaryColor,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateSelector(),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HealthCardRow(),
                      SizedBox(height: 24),
                      _buildSectionHeader('Hoạt động thể thao', Icons.fitness_center),
                      SizedBox(height: 10),
                      _buildSportsCard(),
                      SizedBox(height: 24),
                      _buildSectionHeader('Nhật ký hôm nay', Icons.note_alt),
                      SizedBox(height: 10),
                      _buildDailyLogSection(),
                      SizedBox(height: 24),
                      _buildSectionHeader('Thói quen', Icons.repeat),
                      SizedBox(height: 10),
                      _buildHabitsSection(),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddOptionsDialog,
        backgroundColor: primaryColor,
        icon: Icon(Icons.add),
        label: Text('Thêm'),
        elevation: 4,
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) => Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF30C9B7)),
            SizedBox(width: 8),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      );

  Widget _buildDailyLogSection() {
    final primaryColor = Color(0xFF30C9B7);

    return Consumer<HealthDataProvider>(
      builder: (_, provider, __) {
        final log = provider.dailyLog;
        if (log == null || ((log.workoutLogs?.isEmpty ?? true) && (log.nutritionLogs?.isEmpty ?? true))) {
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/diet.png',
                  height: 60,
                ),
                SizedBox(height: 12),
                Text(
                  'Chưa có dữ liệu cho ngày hôm nay',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddFoodScreen()),
                        );
                      },
                      icon: Icon(Icons.restaurant_menu, size: 16),
                      label: Text('Thêm thực phẩm'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddWorkoutScreen()),
                        );
                      },
                      icon: Icon(Icons.fitness_center, size: 16),
                      label: Text('Thêm bài tập'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        List<Widget> items = [];

        // Hiển thị tiêu đề phần nếu có dữ liệu tương ứng
        if (log.workoutLogs != null && log.workoutLogs!.isNotEmpty) {
          items.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 4.0),
              child: Row(
                children: [
                  Icon(Icons.fitness_center, color: Colors.orange.shade700, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Hoạt động thể thao',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
          items.addAll(_buildWorkoutLogs(provider));
          items.add(SizedBox(height: 16));
        }

        if (log.nutritionLogs != null && log.nutritionLogs!.isNotEmpty) {
          items.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 4.0),
              child: Row(
                children: [
                  Icon(Icons.restaurant, color: Colors.blue.shade700, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Dinh dưỡng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
          items.addAll(_buildNutritionLogs(provider));
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items,
          ),
        );
      },
    );
  }

  List<Widget> _buildWorkoutLogs(HealthDataProvider provider) => provider.dailyLog!.workoutLogs!.map((w) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.fitness_center, color: Colors.orange),
            ),
            title: Text(
              w.name,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              '${w.type} • ${w.durationMinutes} phút',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '-${w.caloriesBurned?.toInt() ?? 0}',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'kcal',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList();

  List<Widget> _buildNutritionLogs(HealthDataProvider provider) => provider.dailyLog!.nutritionLogs!.map((f) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.restaurant, color: Colors.blue),
            ),
            title: Text(
              f.name,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              f.mealType ?? '',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '+${f.calories.toInt()}',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'kcal',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList();

  Widget _buildDateSelector() {
    return Consumer<SelectedDateProvider>(builder: (context, dp, child) {
      final selected = dp.selectedDate;
      final today = DateTime.now();
      final start = selected.subtract(Duration(days: selected.weekday % 7));
      final week = List.generate(7, (i) => start.add(Duration(days: i)));
      final primaryColor = Color(0xFF30C9B7);

      return Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, primaryColor.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: dp.previousWeek,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    DateFormat('MMMM yyyy').format(selected),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: dp.nextWeek,
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 76, // Tăng chiều cao từ 74px lên 90px
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: week.length,
                itemBuilder: (context, index) {
                  final date = week[index];
                  final isSelected = date.year == selected.year && date.month == selected.month && date.day == selected.day;
                  final isToday = date.year == today.year && date.month == today.month && date.day == today.day;

                  return GestureDetector(
                    onTap: () {
                      dp.setDate(date);
                      Provider.of<HealthDataProvider>(context, listen: false).loadDailyLog(date);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          )
                        ] : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('E').format(date),
                            style: TextStyle(
                              color: isSelected ? primaryColor : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isToday && !isSelected ? Colors.white.withOpacity(0.3) : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? primaryColor : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSportsCard() {
    final primaryColor = Color(0xFF30C9B7);

    return Consumer<HealthDataProvider>(
      builder: (_, provider, __) {
        final workouts = provider.dailyLog?.workoutLogs;
        if (workouts == null || workouts.isEmpty) {
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/exercise.png',
                  height: 60,
                ),
                SizedBox(height: 12),
                Text(
                  'Chưa có hoạt động thể thao hôm nay',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                ),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddWorkoutScreen()),
                    );
                  },
                  icon: Icon(Icons.add, color: Colors.white, size: 16),
                  label: Text('Thêm hoạt động', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          );
        }

        int totalMin = workouts.fold(0, (sum, w) => sum + (w.durationMinutes ?? 0));
        int totalCal = workouts.fold(0, (sum, w) => sum + (w.caloriesBurned?.toInt() ?? 0));

        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statItem(Icons.timer, '$totalMin', 'phút', Colors.blue),
                  _statItem(Icons.whatshot, '$totalCal', 'kcal', Colors.orange),
                  _statItem(Icons.fitness_center, '${workouts.length}', 'hoạt động', primaryColor),
                ],
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.verified,
                      color: primaryColor,
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Hoạt động đã hoàn thành',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildHabitsSection() {
    final primaryColor = Color(0xFF30C9B7);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Thói quen uống nước
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFF57C5F8).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/water_glass.png',
                    height: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Uống nước',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Duy trì cơ thể khỏe mạnh',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF57C5F8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '5/8',
                        style: TextStyle(
                          color: Color(0xFF57C5F8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.water_drop,
                        color: Color(0xFF57C5F8),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          // Thói quen tập thể dục
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFFDBBD46).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/exercise.png',
                    height: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tập thể dục',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Hôm nay 30 phút',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // Nút quản lý thói quen
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tính năng quản lý thói quen đang được phát triển'),
                    backgroundColor: primaryColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 44),
              ),
              child: Text('Quản lý thói quen'),
            ),
          ),
        ],
      ),
    );
  }
}
