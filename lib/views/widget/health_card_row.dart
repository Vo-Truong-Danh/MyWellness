import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_wellness/controllers/providers/health_data_provider.dart';
import 'package:my_wellness/controllers/providers/selected_date_provider.dart';
import 'package:my_wellness/views/screens/nutrition_tracking/add_food_screen.dart';

class HealthCardRow extends StatelessWidget {
  const HealthCardRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthDataProvider>(
      builder: (context, healthProvider, child) {
        return RefreshIndicator(
          onRefresh: () async {
            await healthProvider.refreshData();
            healthProvider.notifyListeners();
          },
          color: Color(0xFF30C9B7),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildStepsCard(context, healthProvider),
                    ),
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
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepsCard(
    BuildContext context,
    HealthDataProvider healthProvider,
  ) {
    double currentProgress = healthProvider.getDailyGoalProgress();
    Color progressColor = _getGoalColor(currentProgress);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 64, 218, 245),
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
          SizedBox(height: 30),
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

  Widget _buildHeartRateCard(
    BuildContext context,
    HealthDataProvider healthProvider,
  ) {
    final heartRate = healthProvider.getLatestHeartRate();
    final dateProvider = Provider.of<SelectedDateProvider>(
      context,
      listen: false,
    );

    Color color = Colors.grey;
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
        if (dateProvider.isSelectedDateToday()) {
          // Hiển thị dialog và đợi kết quả
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => _buildHeartRateInputDialog(context),
          );

          // Nếu dialog trả về true nghĩa là đã có dữ liệu được lưu thành công
          if (result == true && context.mounted) {
            // Tải lại dữ liệu và cập nhật UI
            await healthProvider.refreshData();
            Provider.of<HealthDataProvider>(
              context,
              listen: false,
            ).notifyListeners();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Bạn chỉ có thể cập nhật nhịp tim cho ngày hiện tại',
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }

  Widget _buildBloodPressureCard(
    BuildContext context,
    HealthDataProvider healthProvider,
  ) {
    final bloodPressure = healthProvider.getLatestBloodPressure();
    final dateProvider = Provider.of<SelectedDateProvider>(
      context,
      listen: false,
    );

    int? systolic;
    int? diastolic;
    Color color = Colors.grey;

    if (bloodPressure != null) {
      systolic = bloodPressure.systolic;
      diastolic = bloodPressure.diastolic;
      color = _getBloodPressureColor(systolic, diastolic);
    }

    return _buildSmallInfoCard(
      icon: Icons.monitor_heart_outlined,
      iconColor: Colors.purpleAccent,
      label: 'BP',
      value: Text(
        bloodPressure != null
            ? '${bloodPressure.systolic}/${bloodPressure.diastolic}'
            : 'N/A',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        textAlign: TextAlign.center,
      ),
      onTap: () async {
        if (dateProvider.isSelectedDateToday()) {
          // Hiển thị dialog và đợi kết quả
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => _buildBloodPressureInputDialog(context),
          );

          // Nếu dialog trả về true nghĩa là đã có dữ liệu được lưu thành công
          if (result == true && context.mounted) {
            // Tải lại dữ liệu và cập nhật UI
            await healthProvider.refreshData();
            Provider.of<HealthDataProvider>(
              context,
              listen: false,
            ).notifyListeners();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Bạn chỉ có thể cập nhật huyết áp cho ngày hiện tại',
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }

  Widget _buildCalorieCard(
    BuildContext context,
    HealthDataProvider healthProvider,
  ) {
    final calories = healthProvider.getTotalCalories();
    final dateProvider = Provider.of<SelectedDateProvider>(
      context,
      listen: false,
    );

    return _buildSmallInfoCard(
      icon: Icons.local_fire_department,
      iconColor: Colors.orangeAccent,
      label: 'CAL',
      value: Text(
        '${calories.toInt()} kcal',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
        textAlign: TextAlign.center,
      ),
      onTap: () async {
        if (dateProvider.isSelectedDateToday()) {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddFoodScreen()));

          if (context.mounted) {
            final provider = Provider.of<HealthDataProvider>(
              context,
              listen: false,
            );
            provider.notifyListeners();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bạn chỉ có thể thêm thực phẩm cho ngày hiện tại'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }

  Widget _buildSmallInfoCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required Widget value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 20),
                SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            value,
          ],
        ),
      ),
    );
  }

  Widget _buildHeartRateInputDialog(BuildContext context) {
    double heartRate = 70.0;
    bool isSaving = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text(
            'Nhập nhịp tim',
            style: TextStyle(color: Color(0xFF30C9B7)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nhịp tim của bạn (nhịp trên phút):',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '${heartRate.toInt()}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _getHeartRateColor(heartRate),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Color(0xFF30C9B7),
                  inactiveTrackColor: Colors.grey.shade300,
                  thumbColor: Color(0xFF30C9B7),
                  overlayColor: Color(0xFF30C9B7).withOpacity(0.2),
                ),
                child: Slider(
                  min: 40,
                  max: 220,
                  divisions: 180,
                  value: heartRate,
                  onChanged:
                      isSaving
                          ? null
                          : (newValue) {
                            setState(() {
                              heartRate = newValue;
                            });
                          },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('40', style: TextStyle(color: Colors.grey)),
                  Text('220', style: TextStyle(color: Colors.grey)),
                ],
              ),
              SizedBox(height: 10),
              if (heartRate < 60 || heartRate > 100)
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    heartRate < 60
                        ? 'Nhịp tim thấp hơn mức bình thường (60-100 bpm)'
                        : 'Nhịp tim cao hơn mức bình thường (60-100 bpm)',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
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
              onPressed:
                  isSaving
                      ? null
                      : () async {
                        setState(() {
                          isSaving = true;
                        });

                        final healthProvider = Provider.of<HealthDataProvider>(
                          context,
                          listen: false,
                        );
                        final dateProvider = Provider.of<SelectedDateProvider>(
                          context,
                          listen: false,
                        );

                        // Cập nhật UI ngay lập tức trước khi lưu vào cơ sở dữ liệu
                        final existingData =
                            healthProvider.getLatestHeartRate();
                        if (context.mounted) {
                          // Thông báo cho providers biết để cập nhật UI
                          Provider.of<HealthDataProvider>(
                            context,
                            listen: false,
                          ).notifyListeners();
                        }

                        bool success = await healthProvider.addHeartRateReading(
                          heartRate,
                          dateProvider.selectedDate,
                        );

                        if (success) {
                          healthProvider.notifyListeners();
                          Navigator.pop(context, true);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã cập nhật nhịp tim thành công'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          setState(() {
                            isSaving = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Đã xảy ra lỗi khi lưu dữ liệu. Vui lòng thử lại.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
              child:
                  isSaving
                      ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : Text('Lưu'),
            ),
          ],
        );
      },
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
          title: Text(
            'Nhập huyết áp',
            style: TextStyle(color: Color(0xFF30C9B7)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Huyết áp của bạn (mmHg):', style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$systolic',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' / ',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$diastolic',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                'Tâm thu / Tâm trương',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Tâm thu (Systolic):',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Color(0xFF30C9B7),
                  inactiveTrackColor: Colors.grey.shade300,
                  thumbColor: Color(0xFF30C9B7),
                  overlayColor: Color(0xFF30C9B7).withOpacity(0.2),
                ),
                child: Slider(
                  min: 80,
                  max: 200,
                  divisions: 120,
                  value: systolic.toDouble(),
                  onChanged:
                      isSaving
                          ? null
                          : (newValue) {
                            setState(() {
                              systolic = newValue.toInt();
                            });
                          },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '80',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    '200',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Tâm trương (Diastolic):',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Color(0xFF30C9B7),
                  inactiveTrackColor: Colors.grey.shade300,
                  thumbColor: Color(0xFF30C9B7),
                  overlayColor: Color(0xFF30C9B7).withOpacity(0.2),
                ),
                child: Slider(
                  min: 40,
                  max: 120,
                  divisions: 80,
                  value: diastolic.toDouble(),
                  onChanged:
                      isSaving
                          ? null
                          : (newValue) {
                            setState(() {
                              diastolic = newValue.toInt();
                            });
                          },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '40',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    '120',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bpColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: bpColor, size: 20),
                        SizedBox(width: 4),
                        Text(
                          _getBloodPressureMessage(systolic, diastolic),
                          style: TextStyle(
                            color: bpColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
              onPressed:
                  isSaving
                      ? null
                      : () async {
                        setState(() {
                          isSaving = true;
                        });

                        final healthProvider = Provider.of<HealthDataProvider>(
                          context,
                          listen: false,
                        );
                        final dateProvider = Provider.of<SelectedDateProvider>(
                          context,
                          listen: false,
                        );

                        // Cập nhật UI ngay lập tức trước khi lưu vào cơ sở dữ liệu
                        if (context.mounted) {
                          // Thông báo cho providers biết để cập nhật UI
                          Provider.of<HealthDataProvider>(
                            context,
                            listen: false,
                          ).notifyListeners();
                        }

                        bool success = await healthProvider
                            .addBloodPressureReading(
                              systolic,
                              diastolic,
                              dateProvider.selectedDate,
                            );

                        if (success) {
                          healthProvider.notifyListeners();
                          Navigator.pop(
                            context,
                            true,
                          ); // Trả về true để biết đã lưu thành công

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã cập nhật huyết áp thành công'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          setState(() {
                            isSaving = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Đã xảy ra lỗi khi lưu dữ liệu. Vui lòng thử lại.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
              child:
                  isSaving
                      ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  String _getBloodPressureMessage(int systolic, int diastolic) {
    if (systolic > 140 || diastolic > 90) {
      return 'Huyết áp cao';
    } else if (systolic < 90 || diastolic < 60) {
      return 'Huyết áp thấp';
    } else if (systolic > 120 || diastolic > 80) {
      return 'Hơi cao (tiền cao huyết áp)';
    } else {
      return 'Huyết áp bình thường';
    }
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
