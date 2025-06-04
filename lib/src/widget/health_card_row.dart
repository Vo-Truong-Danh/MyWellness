import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_wellness/src/data/providers/health_data_provider.dart';
import 'package:my_wellness/src/data/providers/selected_date_provider.dart';
import 'package:my_wellness/src/screens/nutrition_tracking/add_food_screen.dart';
import 'package:my_wellness/src/screens/workout_tracking/add_workout_screen.dart';

class HealthCardRow extends StatelessWidget {
  const HealthCardRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthDataProvider>(
      builder: (context, healthProvider, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildStepsCard(context, healthProvider)),
            SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildHeartRateCard(context, healthProvider),
                  SizedBox(height: 12),
                  _buildBloodPressureCard(context, healthProvider),
                  SizedBox(height: 12),
                  _buildCalorieCard(context, healthProvider),
                ],
              ),
            ),
          ],
        );
      }
    );
  }

  Widget _buildStepsCard(BuildContext context, HealthDataProvider healthProvider) {
    double currentProgress = healthProvider.getDailyGoalProgress();
    Color progressColor = _getGoalColor(currentProgress);

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
                'Mục tiêu ngày',
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
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
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
                          '${(currentProgress * 100).toInt()}%',
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

  Widget _buildHeartRateCard(BuildContext context, HealthDataProvider healthProvider) {
    // Lấy dữ liệu nhịp tim mới nhất
    final heartRate = healthProvider.getLatestHeartRate();
    final dateProvider = Provider.of<SelectedDateProvider>(context, listen: false);

    // Xác định màu sắc dựa trên giá trị nhịp tim
    Color color = Colors.grey; // Màu mặc định khi không có dữ liệu
    if (heartRate != null) {
      if (heartRate < 60 || heartRate > 100) {
        color = Colors.red;
      } else {
        color = Colors.green;
      }
    }

    return _buildSmallInfoCard(
      icon: Icons.favorite,
      iconColor: Colors.redAccent,
      label: 'HR',
      value: Text(
        heartRate != null ? '${heartRate.toInt()} bpm' : 'N/A',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        textAlign: TextAlign.center,
      ),
      onTap: () async {
        // Chỉ cho phép cập nhật nếu là ngày hiện tại
        if (dateProvider.isSelectedDateToday()) {
          await showDialog(
            context: context,
            builder: (context) => _buildHeartRateInputDialog(context),
          );
        } else {
          // Hiển thị thông báo nếu không phải ngày hiện tại
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Chỉ có thể cập nhật nhịp tim cho ngày hôm nay'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }

  Widget _buildBloodPressureCard(BuildContext context, HealthDataProvider healthProvider) {
    // Lấy dữ liệu huyết áp mới nhất
    final bloodPressure = healthProvider.getLatestBloodPressure();
    final dateProvider = Provider.of<SelectedDateProvider>(context, listen: false);

    Color color = Colors.grey; // Màu mặc định khi không có dữ liệu
    String displayText = 'N/A';

    if (bloodPressure != null) {
      displayText = '${bloodPressure.systolic}/${bloodPressure.diastolic}';

      if (bloodPressure.systolic > 140 || bloodPressure.diastolic > 90 ||
          bloodPressure.systolic < 90 || bloodPressure.diastolic < 60) {
        color = Colors.red;
      } else if (bloodPressure.systolic > 120 || bloodPressure.diastolic > 80) {
        color = Colors.orange;
      } else {
        color = Colors.green;
      }
    }

    return _buildSmallInfoCard(
      icon: Icons.bloodtype,
      iconColor: Colors.blueAccent,
      label: 'BP',
      value: Text(
        displayText,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        textAlign: TextAlign.center,
      ),
      onTap: () async {
        // Chỉ cho phép cập nhật nếu là ngày hiện tại
        if (dateProvider.isSelectedDateToday()) {
          await showDialog(
            context: context,
            builder: (context) => _buildBloodPressureInputDialog(context),
          );
        } else {
          // Hiển thị thông báo nếu không phải ngày hiện tại
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Chỉ có thể cập nhật huyết áp cho ngày hôm nay'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }

  Widget _buildCalorieCard(BuildContext context, HealthDataProvider healthProvider) {
    // Lấy dữ liệu calories
    final calories = healthProvider.getTotalCalories();
    final calorieTarget = healthProvider.userData?.dailyCalorieTarget ?? 1500.0;

    Color color;
    if (calories >= calorieTarget) {
      color = Colors.red;
    } else if (calories >= calorieTarget * 0.75) {
      color = Colors.green;
    } else if (calories >= calorieTarget * 0.35) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return _buildSmallInfoCard(
      icon: Icons.local_fire_department,
      iconColor: Colors.orangeAccent,
      label: 'Kcal',
      value: Text(
        '${calories.toInt()}',
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      onTap: () {
        // Điều hướng đến màn hình thêm món ăn
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddFoodScreen()),
        );
      },
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

  Widget _buildHeartRateInputDialog(BuildContext context) {
    double heartRate = 70;
    bool isSaving = false;

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
      }
    );
  }

  Widget _buildBloodPressureInputDialog(BuildContext context) {
    int systolic = 120;
    int diastolic = 80;
    bool isSaving = false;

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
      }
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

  Color _getGoalColor(double progress) {
    if (progress >= 0.75) {
      return Colors.green;
    } else if (progress >= 0.35) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
