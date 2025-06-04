import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_wellness/src/screens/habits/addhabit.dart';
import 'package:my_wellness/src/screens/nutrition_tracking/add_food_screen.dart';
import 'package:my_wellness/src/screens/workout_tracking/add_workout_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_wellness/src/data/providers/health_data_provider.dart';
import 'package:my_wellness/src/data/providers/selected_date_provider.dart';
import 'package:my_wellness/src/screens/home/homepage.dart';

/// Hiển thị ModalBottomSheet với các tùy chọn thêm mới
class AddOptionsBottomSheet extends StatelessWidget {
  const AddOptionsBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle/Pill trên cùng
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Tiêu đề
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  'Thêm mới',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tùy chọn thêm món ăn
          _buildOptionTile(
            context,
            icon: Icons.restaurant_menu,
            iconColor: Colors.orange,
            title: 'Thêm món ăn',
            subtitle: 'Ghi lại các món ăn và dinh dưỡng',
            onTap: () {
              // Phản hồi xúc giác (rung)
              HapticFeedback.lightImpact();

              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFoodScreen()),
              );
            },
          ),

          const Divider(height: 1, indent: 16, endIndent: 16),

          // Tùy chọn thêm bài tập
          _buildOptionTile(
            context,
            icon: Icons.fitness_center,
            iconColor: Color(0xFF30C9B7),
            title: 'Thêm bài tập',
            subtitle: 'Ghi lại hoạt động thể thao của bạn',
            onTap: () {
              // Phản hồi xúc giác (rung)
              HapticFeedback.lightImpact();

              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddWorkoutScreen()),
              );
            },
          ),

          const Divider(height: 1, indent: 16, endIndent: 16),

          // Tùy chọn thêm chỉ số sức khỏe
          _buildOptionTile(
            context,
            icon: Icons.favorite,
            iconColor: Colors.redAccent,
            title: 'Thêm chỉ số sức khỏe',
            subtitle: 'Nhịp tim, huyết áp và các chỉ số khác',
            onTap: () {
              // Phản hồi xúc giác (rung)
              HapticFeedback.lightImpact();

              Navigator.of(context).pop();
              _showUpdateHealthDialog(context);
            },
          ),

          const Divider(height: 1, indent: 16, endIndent: 16),

          // Tùy chọn thêm thói quen
          _buildOptionTile(
            context,
            icon: Icons.repeat,
            iconColor: Colors.deepPurpleAccent,
            title: 'Thêm thói quen',
            subtitle: 'Tạo và theo dõi thói quen hàng ngày',
            onTap: () {
              // Phản hồi xúc giác (rung)
              HapticFeedback.lightImpact();

              Navigator.of(context).pop();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) => AddHabitBottomSheet(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 26,
          color: iconColor,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      onTap: onTap,
    );
  }

  void _showUpdateHealthDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => HealthMetricsBottomSheet(),
    );
  }

  // Các hàm hiển thị dialog được cải tiến với giao diện hiện đại
  void _showWeightInputDialog(BuildContext context) {
    double weight = Provider.of<HealthDataProvider>(context, listen: false).userData?.weight ?? 60.0;
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                'Cập nhật cân nặng',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF30C9B7),
                ),
              ),
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
                      HapticFeedback.selectionClick();
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
                  child: Text('Hủy', style: TextStyle(color: Colors.grey[700])),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF30C9B7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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

                    if (success) {
                      // Refresh homepage data
                      HomePage.refreshData();

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Cập nhật cân nặng thành công'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                'Cập nhật nhịp tim',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: heartRateColor,
                ),
              ),
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
                      HapticFeedback.selectionClick();
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
                  child: Text('Hủy', style: TextStyle(color: Colors.grey[700])),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF30C9B7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                      // Refresh homepage data
                      HomePage.refreshData();

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Cập nhật nhịp tim thành công'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                'Cập nhật huyết áp',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: bpColor,
                ),
              ),
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
                      HapticFeedback.selectionClick();
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
                      HapticFeedback.selectionClick();
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
                  child: Text('Hủy', style: TextStyle(color: Colors.grey[700])),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF30C9B7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                      // Refresh homepage data
                      HomePage.refreshData();

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Cập nhật huyết áp thành công'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {
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
}

/// Bottom sheet hiển thị các tùy chọn chỉ số sức khỏe
class HealthMetricsBottomSheet extends StatelessWidget {
  const HealthMetricsBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle/Pill trên cùng
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Tiêu đề
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  'Cập nhật chỉ số sức khỏe',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tùy chọn cập nhật cân nặng
          _buildOptionTile(
            context,
            icon: Icons.monitor_weight,
            iconColor: Color(0xFF30C9B7),
            title: 'Cập nhật cân nặng',
            onTap: () {
              Navigator.of(context).pop();
              _showWeightInputDialog(context);
            },
          ),

          // Tùy chọn cập nhật nhịp tim
          _buildOptionTile(
            context,
            icon: Icons.favorite,
            iconColor: Colors.redAccent,
            title: 'Cập nhật nhịp tim',
            onTap: () {
              Navigator.of(context).pop();
              _showHeartRateDialog(context);
            },
          ),

          // Tùy chọn cập nhật huyết áp
          _buildOptionTile(
            context,
            icon: Icons.bloodtype,
            iconColor: Colors.blueAccent,
            title: 'Cập nhật huyết áp',
            onTap: () {
              Navigator.of(context).pop();
              _showBloodPressureDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      leading: Icon(icon, color: iconColor, size: 28),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                'Cập nhật cân nặng',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF30C9B7),
                ),
              ),
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
                      HapticFeedback.selectionClick();
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
                  child: Text('Hủy', style: TextStyle(color: Colors.grey[700])),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF30C9B7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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

                    if (success) {
                      // Refresh homepage data
                      HomePage.refreshData();

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Cập nhật cân nặng thành công'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                'Cập nhật nhịp tim',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: heartRateColor,
                ),
              ),
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
                      HapticFeedback.selectionClick();
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
                  child: Text('Hủy', style: TextStyle(color: Colors.grey[700])),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF30C9B7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                      // Refresh homepage data
                      HomePage.refreshData();

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Cập nhật nhịp tim thành công'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                'Cập nhật huyết áp',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: bpColor,
                ),
              ),
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
                      HapticFeedback.selectionClick();
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
                      HapticFeedback.selectionClick();
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
                  child: Text('Hủy', style: TextStyle(color: Colors.grey[700])),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF30C9B7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                      // Refresh homepage data
                      HomePage.refreshData();

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Cập nhật huyết áp thành công'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {
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
}

