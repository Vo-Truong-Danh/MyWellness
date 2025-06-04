import 'package:flutter/material.dart';
import 'package:my_wellness/src/core/recipe/identify_3_colors.dart';
import 'package:my_wellness/src/screens/habits/addhabit.dart';
import 'package:my_wellness/src/widget/habitcountcheck.dart';
import 'package:my_wellness/src/widget/habittaskcheck.dart';
import 'package:my_wellness/src/widget/health_card_row.dart';
import 'package:provider/provider.dart';
import 'package:my_wellness/src/data/providers/health_data_provider.dart';
import 'package:my_wellness/src/data/providers/selected_date_provider.dart';
import 'package:my_wellness/src/screens/nutrition_tracking/add_food_screen.dart';
import 'package:my_wellness/src/screens/workout_tracking/add_workout_screen.dart';
import 'package:intl/intl.dart';

class HomePageV2 extends StatefulWidget {
  const HomePageV2({Key? key}) : super(key: key);

  @override
  _HomePageV2State createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePageV2> {
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

        // Tải nhật ký sức khỏe của ngày được chọn
        healthProvider.loadDailyLog(dateProvider.selectedDate);
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
        title: Text(
          "Dữ liệu sức khỏe",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 21,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showUpdateHealthDialog(context);
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
          _showAddOptionsDialog(context);
        },
        backgroundColor: Color(0xFF30C9B7),
        tooltip: 'Thêm mới',
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateSelector(),
            SizedBox(height: 20),
            HealthCardRow(),
            SizedBox(height: 20),
            _buildSectionHeader('Hoạt động thể thao'),
            _buildSportsCard(),
            SizedBox(height: 20),
            _buildSectionHeader('Nhật ký hôm nay'),
            Consumer<HealthDataProvider>(
              builder: (context, provider, child) {
                if (provider.dailyLog == null ||
                    (provider.dailyLog!.workoutLogs == null || provider.dailyLog!.workoutLogs!.isEmpty) &&
                    (provider.dailyLog!.nutritionLogs == null || provider.dailyLog!.nutritionLogs!.isEmpty)) {
                  return _buildEmptyState('Chưa có dữ liệu cho ngày hôm nay');
                }

                return Column(
                  children: [
                    // Hiển thị các bài tập đã ghi nhận
                    if (provider.dailyLog!.workoutLogs != null && provider.dailyLog!.workoutLogs!.isNotEmpty)
                      ..._buildWorkoutLogs(provider),
                    SizedBox(height: 10),
                    // Hiển thị các món ăn đã ghi nhận
                    if (provider.dailyLog!.nutritionLogs != null && provider.dailyLog!.nutritionLogs!.isNotEmpty)
                      ..._buildNutritionLogs(provider),
                  ],
                );
              },
            ),
            SizedBox(height: 16),
            _buildSectionHeader('Thói quen'),
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
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
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
                  onPressed: () {
                    dateProvider.setDate(DateTime.now());
                    Provider.of<HealthDataProvider>(context, listen: false)
                      .loadDailyLog(DateTime.now());
                  },
                  child: Text(
                    "Hôm nay",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF30C9B7),
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
                    onTap: () {
                      dateProvider.setDate(date);
                      Provider.of<HealthDataProvider>(context, listen: false)
                        .loadDailyLog(date);
                    },
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
            SizedBox(height: 16),
            Divider(),
          ],
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getWeekdayLabel(int weekday) {
    final labels = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    return labels[weekday % 7];
  }

  Widget _buildSportsCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddWorkoutScreen()),
        );
      },
      child: Container(
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
                    'Thêm bài tập',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Ghi lại các hoạt động thể thao của bạn',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildWorkoutLogs(HealthDataProvider provider) {
    final workouts = provider.dailyLog!.workoutLogs!;

    return [
      _buildSectionHeader('Bài tập', icon: Icons.fitness_center),
      ...workouts.map((workout) => _buildWorkoutItem(workout)).toList(),
    ];
  }

  Widget _buildWorkoutItem(workout) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF30C9B7).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.fitness_center,
              color: Color(0xFF30C9B7),
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  workout.type + (workout.durationMinutes != null ? ' • ${workout.durationMinutes} phút' : ''),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${workout.caloriesBurned?.toInt() ?? 0} kcal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 2),
              Text(
                DateFormat('HH:mm').format(workout.loggedAt),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNutritionLogs(HealthDataProvider provider) {
    final foods = provider.dailyLog!.nutritionLogs!;

    return [
      _buildSectionHeader('Nhật ký ăn uống', icon: Icons.restaurant),
      ...foods.map((food) => _buildFoodItem(food)).toList(),
    ];
  }

  Widget _buildFoodItem(food) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restaurant,
              color: Colors.orange,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  food.mealType ?? 'Bữa ăn',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${food.calories.toInt()} kcal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 2),
              Text(
                DateFormat('HH:mm').format(food.loggedAt),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Colors.grey[700]),
            SizedBox(width: 6),
          ],
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      height: 120,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.grey[400],
            size: 40,
          ),
          SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateHealthDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cập nhật thể trạng'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.monitor_weight, color: Color(0xFF30C9B7)),
              title: Text('Cập nhật cân nặng'),
              onTap: () {
                Navigator.pop(context);
                _showWeightInputDialog(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.redAccent),
              title: Text('Cập nhật nhịp tim'),
              onTap: () {
                Navigator.pop(context);
                _showHeartRateDialog(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.bloodtype, color: Colors.blueAccent),
              title: Text('Cập nhật huyết áp'),
              onTap: () {
                Navigator.pop(context);
                _showBloodPressureDialog(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showWeightInputDialog(BuildContext context) {
    double weight = Provider.of<HealthDataProvider>(context, listen: false).userData?.weight ?? 60.0;
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Cập nhật cân nặng'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${weight.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF30C9B7),
                        ),
                      ),
                      Text(' kg', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Slider(
                    value: weight,
                    min: 30.0,
                    max: 150.0,
                    divisions: 240,
                    activeColor: Color(0xFF30C9B7),
                    onChanged: (value) {
                      setState(() {
                        weight = value;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('30 kg', style: TextStyle(color: Colors.grey)),
                      Text('150 kg', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.pop(context),
                  child: Text('Hủy'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF30C9B7),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isSaving
                      ? null
                      : () async {
                          setState(() {
                            isSaving = true;
                          });

                          final healthProvider = Provider.of<HealthDataProvider>(context, listen: false);
                          final dateProvider = Provider.of<SelectedDateProvider>(context, listen: false);

                          bool success = await healthProvider.updateWeight(
                            weight,
                            dateProvider.selectedDate,
                          );

                          if (!mounted) return;

                          if (success) {
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              isSaving = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Đã xảy ra lỗi khi lưu dữ liệu. Vui lòng thử lại.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  child: isSaving
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showHeartRateDialog(BuildContext context) {
    double heartRate = 70;
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Color heartRateColor = _getHeartRateColor(heartRate);

            return AlertDialog(
              title: Text('Cập nhật nhịp tim'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${heartRate.toInt()}',
                        style: TextStyle(
                          fontSize: 40,
                          color: heartRateColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(' bpm', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Slider(
                    value: heartRate,
                    min: 30,
                    max: 200,
                    divisions: 170,
                    activeColor: heartRateColor,
                    onChanged: (value) {
                      setState(() {
                        heartRate = value;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('30', style: TextStyle(color: Colors.grey)),
                      Text('200', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.pop(context),
                  child: Text('Hủy'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF30C9B7),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isSaving ? null : () async {
                    setState(() {
                      isSaving = true;
                    });

                    final healthProvider = Provider.of<HealthDataProvider>(context, listen: false);
                    final dateProvider = Provider.of<SelectedDateProvider>(context, listen: false);

                    bool success = await healthProvider.addHeartRateReading(
                      heartRate,
                      dateProvider.selectedDate,
                    );

                    if (!mounted) return;

                    if (success) {
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        isSaving = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã xảy ra lỗi khi lưu dữ liệu. Vui lòng thử lại.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: isSaving
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      )
                    : Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBloodPressureDialog(BuildContext context) {
    int systolic = 120;
    int diastolic = 80;
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Color bpColor = _getBloodPressureColor(systolic, diastolic);

            return AlertDialog(
              title: Text('Cập nhật huyết áp'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$systolic / $diastolic',
                        style: TextStyle(
                          fontSize: 40,
                          color: bpColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(' mmHg', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('Tâm thu (Systolic)', style: TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: systolic.toDouble(),
                    min: 70,
                    max: 200,
                    divisions: 130,
                    activeColor: bpColor,
                    onChanged: (value) {
                      setState(() {
                        systolic = value.toInt();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('70', style: TextStyle(color: Colors.grey)),
                      Text('200', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('Tâm trương (Diastolic)', style: TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: diastolic.toDouble(),
                    min: 40,
                    max: 130,
                    divisions: 90,
                    activeColor: bpColor,
                    onChanged: (value) {
                      setState(() {
                        diastolic = value.toInt();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('40', style: TextStyle(color: Colors.grey)),
                      Text('130', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.pop(context),
                  child: Text('Hủy'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF30C9B7),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isSaving ? null : () async {
                    setState(() {
                      isSaving = true;
                    });

                    final healthProvider = Provider.of<HealthDataProvider>(context, listen: false);
                    final dateProvider = Provider.of<SelectedDateProvider>(context, listen: false);

                    bool success = await healthProvider.addBloodPressureReading(
                      systolic,
                      diastolic,
                      dateProvider.selectedDate,
                    );

                    if (!mounted) return;

                    if (success) {
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        isSaving = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã xảy ra lỗi khi lưu dữ liệu. Vui lòng thử lại.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: isSaving
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      )
                    : Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Color _getHeartRateColor(double hr) {
    if (hr < 60 || hr > 100) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  Color _getBloodPressureColor(int systolic, int diastolic) {
    if (systolic > 140 || diastolic > 90 || systolic < 90 || diastolic < 60) {
      return Colors.red;
    } else if (systolic > 120 || diastolic > 80) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  void _showAddOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Thêm mới'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFoodScreen()),
              );
            },
            child: Row(
              children: [
                Icon(Icons.restaurant, color: Colors.orange),
                SizedBox(width: 10),
                Text('Thêm món ăn'),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddWorkoutScreen()),
              );
            },
            child: Row(
              children: [
                Icon(Icons.fitness_center, color: Color(0xFF30C9B7)),
                SizedBox(width: 10),
                Text('Thêm bài tập'),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                builder: (context) => AddHabitBottomSheet(),
              );
            },
            child: Row(
              children: [
                Icon(Icons.repeat, color: Colors.purple),
                SizedBox(width: 10),
                Text('Thêm thói quen'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
